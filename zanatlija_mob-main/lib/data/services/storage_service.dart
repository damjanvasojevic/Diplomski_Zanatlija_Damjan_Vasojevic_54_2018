import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(File file) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      await _storage.ref('images/$fileName').putFile(file);

      final downloadUrl =
          await _storage.ref('images/$fileName').getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
