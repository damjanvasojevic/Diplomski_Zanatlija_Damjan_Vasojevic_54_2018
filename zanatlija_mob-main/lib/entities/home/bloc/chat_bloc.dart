// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zanatlija_app/data/models/chat.dart';
import 'package:zanatlija_app/data/models/user.dart';
import 'package:zanatlija_app/data/services/firestore_service.dart';
import 'package:zanatlija_app/navigation/router.gr.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirestoreService firestoreService;

  StreamSubscription? _firebaseChatUpdatedSubscription;
  ChatBloc(this.firestoreService) : super(ChatInitial()) {
    on<CreateChatWithUserEvent>(_createChatWithUser);
    on<GetChatsForUserEvent>(_getAllChatsForUser);
    on<GetChatByIdEvent>(_getChatById);
    on<NotifyChatRoomEvent>(_emitChatUpdate);
    on<AddMessageToChatEvent>(_addNewMessageToChat);
  }

  @override
  Future<void> close() {
    _firebaseChatUpdatedSubscription?.cancel();
    return super.close();
  }

  Future<void> _emitChatUpdate(
      NotifyChatRoomEvent event, Emitter<ChatState> emit) async {
    emit(UpdateChatRoomState(event.chat));
  }

  Future<void> _createChatWithUser(
      CreateChatWithUserEvent event, Emitter<ChatState> emit) async {
    try {
      final docId = await firestoreService.getIdOrcreateChatWithUser(
          event.chat, event.user);
      final chat = await firestoreService.getChatById(docId);

      emit(GetByIdSuccess(chat));
      AutoRouter.of(event.context).maybePop(docId);

      add(GetChatByIdEvent(docId, event.context));
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  Future<void> _getAllChatsForUser(
      GetChatsForUserEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState());
    try {
      final chats = await firestoreService.getAllChatsForUser(event.user);
      await Future.delayed(const Duration(milliseconds: 500));
      emit(GetAllChatsForUserSuccess(chats));
    } catch (e) {
      emit(GetAllChatsForUserError(e.toString()));
      debugPrint('Error $e');
    }
  }

  Future<void> _addNewMessageToChat(
      AddMessageToChatEvent event, Emitter<ChatState> emit) async {
    try {
      await firestoreService.updateChat(event.chat);
    } catch (e) {
      emit(GetAllChatsForUserError(e.toString()));
      debugPrint('Error $e');
    }
  }

  Future<void> setupChatRoomSubscription(String id) async {
    _firebaseChatUpdatedSubscription =
        firestoreService.getChatCollectionReference.doc(id).snapshots().listen(
      (event) {
        if (event.data() == null) {
          return;
        }
        final data = Chat.fromJson(event.data()!);
        add(NotifyChatRoomEvent(data));
      },
    );
  }

  Future<void> closeStream() async {
    await _firebaseChatUpdatedSubscription?.cancel();
  }

  Future<void> _getChatById(
      GetChatByIdEvent event, Emitter<ChatState> emit) async {
    try {
      final chat = await firestoreService.getChatById(event.id);
      AutoRouter.of(event.context).push(
        ChatRoom(chat: chat),
      );
      emit(GetByIdSuccess(chat));
    } catch (e) {
      emit(GetByIdError(e.toString()));
      debugPrint('Error $e');
    }
  }
}
