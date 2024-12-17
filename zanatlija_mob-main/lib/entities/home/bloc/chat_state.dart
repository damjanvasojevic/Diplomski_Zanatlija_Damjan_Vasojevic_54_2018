part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChattStateError extends ChatState {
  final String error;
  const ChattStateError(this.error);
}

final class UpdateChatRoomState extends ChatState {
  final Chat chat;
  const UpdateChatRoomState(this.chat);

  @override
  List<Object> get props => [chat];
}

final class ChatWithUserCreatedState extends ChatState {
  final String chatId;
  const ChatWithUserCreatedState(this.chatId);

  @override
  List<Object> get props => [chatId];
}

final class GetAllChatsForUserSuccess extends ChatState {
  final List<Chat> chats;
  const GetAllChatsForUserSuccess(this.chats);

  @override
  List<Object> get props => [chats];
}

final class GetAllChatsForUserError extends ChattStateError {
  const GetAllChatsForUserError(super.error);
}

final class GetByIdSuccess extends ChatState {
  final Chat chat;
  const GetByIdSuccess(this.chat);

  @override
  List<Object> get props => [chat];
}

final class GetByIdError extends ChattStateError {
  const GetByIdError(super.error);
}

final class ChatLoadingState extends ChatState {}
