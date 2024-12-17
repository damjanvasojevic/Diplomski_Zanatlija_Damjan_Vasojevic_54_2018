part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class CreateChatWithUserEvent extends ChatEvent {
  final Chat chat;
  final User user;
  final BuildContext context;
  const CreateChatWithUserEvent(
    this.chat,
    this.user,
    this.context,
  );

  @override
  List<Object> get props => [chat, user, context];
}

class GetChatsForUserEvent extends ChatEvent {
  final User user;
  const GetChatsForUserEvent(this.user);

  @override
  List<Object> get props => [user];
}

class GetChatByIdEvent extends ChatEvent {
  final String id;
  final BuildContext context;
  const GetChatByIdEvent(
    this.id,
    this.context,
  );

  @override
  List<Object> get props => [id, context];
}

class AddMessageToChatEvent extends ChatEvent {
  final Chat chat;
  const AddMessageToChatEvent(this.chat);

  @override
  List<Object> get props => [chat];
}

class NotifyChatRoomEvent extends ChatEvent {
  final Chat chat;
  const NotifyChatRoomEvent(this.chat);

  @override
  List<Object> get props => [chat];
}
