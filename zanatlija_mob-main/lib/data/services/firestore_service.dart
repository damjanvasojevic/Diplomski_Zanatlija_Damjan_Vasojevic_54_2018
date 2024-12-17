import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zanatlija_app/data/models/chat.dart';
import 'package:zanatlija_app/data/models/craft.dart';
import 'package:zanatlija_app/data/models/user.dart';
import 'package:zanatlija_app/utils/app_mixin.dart';

enum LoginError {
  userNotFound,
  passwordIsWrong,
  unknownError,
}

class FirestoreService with AppMixin {
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  final kUserCollection = 'users';
  final kCraftCollection = 'crafts';
  final kChatCollection = 'chats';

  CollectionReference<Map<String, dynamic>> get getUserCollectionReference =>
      firestoreInstance.collection(kUserCollection);
  CollectionReference<Map<String, dynamic>> get getChatCollectionReference =>
      firestoreInstance.collection(kChatCollection);
  Future<void> createUser(User user) async {
    try {
      final collectionReference = firestoreInstance.collection(kUserCollection);
      await collectionReference.doc(user.phoneNumber).set(user.toJson());
    } catch (e) {}
  }

  Future<String> getIdOrcreateChatWithUser(Chat chat, User user) async {
    try {
      final userCollectionReference =
          firestoreInstance.collection(kUserCollection);
      final chatCollectionReference =
          firestoreInstance.collection(kChatCollection);

      final querySnapshot = await chatCollectionReference
          .where('participantsIds', arrayContains: user.phoneNumber)
          .get();

      for (final doc in querySnapshot.docs) {
        final chatFromDoc = Chat.fromJson(doc.data());
        final participants = chatFromDoc.participants;
        final otherUserId =
            participants.firstWhere((e) => e.userId != user.phoneNumber).userId;
        if (participants.any((element) => element.userId == otherUserId)) {
          return doc.id;
        }
      }
      final docId = chatCollectionReference.doc().id;
      chat.id = docId;

      final userIds = chat.participants.map((e) => e.userId).toList();
      for (final id in userIds) {
        await userCollectionReference.doc(id).update(
          {
            'chats': FieldValue.arrayUnion([chat.id]),
          },
        );
      }
      await chatCollectionReference.doc(chat.id).set(chat.toJson());
      return docId;
    } catch (e) {
      return '';
    }
  }

  Future<List<Craft>> getAllCrafts(User user) async {
    List<Craft> crafts = [];
    try {
      final collectionReference =
          firestoreInstance.collection(kCraftCollection);
      final data = await collectionReference.get();

      for (final doc
          in data.docs.where((e) => e.id != user.phoneNumber).toList()) {
        crafts.add(Craft.fromJson(doc.data()));
      }
      return crafts;
    } catch (error) {
      return crafts;
    }
  }

  Future<User> autologin(String phoneNumber, String password) async {
    final userDoc = await firestoreInstance
        .collection(kUserCollection)
        .doc(phoneNumber)
        .get();

    return User.fromJson(userDoc.data()!);
  }

  Future<User?> login(String phoneNumber, String password) async {
    try {
      final hashedPassword = getHashedPassword(password);
      final userDoc = await firestoreInstance
          .collection(kUserCollection)
          .doc(phoneNumber)
          .get();

      if (userDoc.exists) {
        if (userDoc['password'] == hashedPassword) {
          return User.fromJson(userDoc.data()!);
        } else {
          throw LoginError.passwordIsWrong;
        }
      }
      throw LoginError.userNotFound;
    } catch (e) {
      throw LoginError.unknownError;
    }
  }

  Future<void> addCraft(Craft craft, User user) async {
    try {
      final userCollectionReference =
          firestoreInstance.collection(kUserCollection);
      final craftCollectionReference =
          firestoreInstance.collection(kCraftCollection);
      final id = craftCollectionReference.doc().id;
      user.myJobs?.add(id);
      craft.id = id;
      await Future.wait([
        userCollectionReference.doc(user.phoneNumber).update(user.toJson()),
        craftCollectionReference.doc(id).set(craft.toJson())
      ]);
    } catch (error) {}
  }

  Future<List<Chat>> getAllChatsForUser(User user) async {
    List<Chat> chats = [];
    try {
      final collectionReference = firestoreInstance.collection(kChatCollection);
      List<QuerySnapshot<Map<String, dynamic>>> snapshotList = [];
      for (final id in user.chats!) {
        final data = await collectionReference.where('id', isEqualTo: id).get();
        snapshotList.add(data);
      }
      for (final querysnapshot in snapshotList) {
        for (final doc in querysnapshot.docs
            .where((e) => e.id != user.phoneNumber)
            .toList()) {
          chats.add(Chat.fromJson(doc.data()));
        }
      }

      return chats;
    } catch (error) {
      return chats;
    }
  }

  Future<Chat> getChatById(String id) async {
    late Chat chat;
    try {
      final collectionReference = firestoreInstance.collection(kChatCollection);

      final data = await collectionReference.where('id', isEqualTo: id).get();

      for (final doc in data.docs) {
        chat = Chat.fromJson(doc.data());
      }

      return chat;
    } catch (error) {
      return Chat(chatNodes: [], participants: [], participantsIds: []);
    }
  }

  Future<void> updateChat(Chat chat) async {
    try {
      final userCollectionReference =
          firestoreInstance.collection(kChatCollection);

      await userCollectionReference.doc(chat.id).update(chat.toJson());
    } catch (error) {}
  }

  Future<void> deleteCraft(String craftId) async {
    try {
      final craftCollectionRef = firestoreInstance.collection(kCraftCollection);
      final userCollectionRef = firestoreInstance.collection(kUserCollection);
      final savedCraftsQuerySnapshot = await userCollectionRef
          .where('savedCrafts', arrayContains: craftId)
          .get();

      //remove all savedCrafts
      for (final doc in savedCraftsQuerySnapshot.docs) {
        final userFromDoc = User.fromJson(doc.data());
        userFromDoc.savedCrafts?.removeWhere((element) => element == craftId);
        await updateFirestoreUser(userFromDoc);
      }

      //remove myJob
      final myJobsQuerySnapshot =
          await userCollectionRef.where('myJobs', arrayContains: craftId).get();

      final userFromDoc = User.fromJson(myJobsQuerySnapshot.docs.first.data());
      userFromDoc.myJobs?.removeWhere((element) => element == craftId);
      await updateFirestoreUser(userFromDoc);

      //remove craft from collection
      await craftCollectionRef.doc(craftId).delete();
    } catch (error) {}
  }

  Future<void> updateFirestoreUser(User user) async {
    try {
      final userCollectionReference =
          firestoreInstance.collection(kUserCollection);

      await userCollectionReference.doc(user.phoneNumber).update(user.toJson());
    } catch (error) {}
  }
}
