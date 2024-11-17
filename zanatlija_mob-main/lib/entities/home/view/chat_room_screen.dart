import 'package:auto_route/auto_route.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zanatlija_app/data/models/chat.dart';
import 'package:zanatlija_app/data/models/chat_node.dart';
import 'package:zanatlija_app/data/models/user.dart';
import 'package:zanatlija_app/entities/home/bloc/chat_bloc.dart';
import 'package:zanatlija_app/entities/login/bloc/user_bloc.dart';
import 'package:zanatlija_app/utils/app_mixin.dart';
import 'package:zanatlija_app/utils/common_widgets.dart';

@RoutePage()
class ChatRoom extends StatefulWidget {
  final Chat chat;
  const ChatRoom(this.chat, {super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with AppMixin {
  final TextEditingController _chatTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late Chat _chat;
  late User _myUser;

  @override
  void initState() {
    super.initState();
    _chat = widget.chat;
    _myUser = BlocProvider.of<UserBloc>(context).state.user!;
    BlocProvider.of<ChatBloc>(context).setupChatRoomSubscription(_chat.id);
    // Scroll to bottom on initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _isMyMessage(ChatNode node) {
    return node.userId == _myUser.phoneNumber;
  }

  String _capitalizeFirstLetterOfEachWord(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
      return word;
    }).join(' ');
  }

  String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return "Upravo sada";
    } else if (difference.inMinutes < 60) {
      return "pre ${difference.inMinutes} minuta";
    } else if (difference.inDays == 0) {
      return DateFormat.Hm().format(timestamp);
    } else if (difference.inDays == 1) {
      return "Juče";
    } else if (difference.inDays < 7) {
      return _capitalizeFirstLetterOfEachWord(
          DateFormat.EEEE('sr_RS').format(timestamp));
    } else {
      return _capitalizeFirstLetterOfEachWord(
          DateFormat('dd MMM', 'sr_RS').format(timestamp));
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sender =
        _chat.participants.firstWhere((e) => e.userId != _myUser.phoneNumber);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45,
        title: Text(
          "Chat sa ${sender.username}",
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 32, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).cardColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_sharp,
              color: Colors.white, size: 30),
          onPressed: () {
            BlocProvider.of<ChatBloc>(context).closeStream();
            AutoRouter.of(context).maybePop();
          },
        ),
      ),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is UpdateChatRoomState) {
            setState(() {
              _chat = state.chat;
            });

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).cardColor,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller:
                                _scrollController, // Set the ScrollController here
                            itemCount: _chat.chatNodes.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  trailing:
                                      !_isMyMessage(_chat.chatNodes[index])
                                          ? null
                                          : Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Theme.of(context)
                                                      .backgroundColor,
                                                  border: Border.all(width: 1)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Text(_chat
                                                    .chatNodes[index]
                                                    .senderUsername[0]),
                                              ),
                                            ),
                                  leading: _isMyMessage(_chat.chatNodes[index])
                                      ? null
                                      : Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                              border: Border.all(width: 1)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(_chat.chatNodes[index]
                                                .senderUsername[0]),
                                          ),
                                        ),
                                  title: BubbleSpecialThree(
                                    text: _chat.chatNodes[index].message,
                                    color: const Color(0xFFE8E8EE),
                                    tail: false,
                                    isSender:
                                        _isMyMessage(_chat.chatNodes[index]),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: CommonTextField(
                                    'Poruka..', _chatTextController)),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColorDark,
                                    shape: BoxShape.circle),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: IconButton(
                                    color: Colors.white,
                                    icon: const Icon(Icons.send),
                                    onPressed: () {
                                      final user =
                                          BlocProvider.of<UserBloc>(context)
                                              .state
                                              .user!;
                                      final chatNode = ChatNode(
                                          id: UniqueKey().hashCode.toString(),
                                          userId: user.phoneNumber,
                                          message: _chatTextController.text,
                                          senderUsername: user.nameSurname,
                                          timeStampInMillis: DateTime.now()
                                              .millisecondsSinceEpoch);
                                      _chat.chatNodes.add(chatNode);
                                      BlocProvider.of<ChatBloc>(context)
                                          .add(AddMessageToChatEvent(_chat));
                                      _chatTextController.clear();
                                      hideKeyboard(context);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
