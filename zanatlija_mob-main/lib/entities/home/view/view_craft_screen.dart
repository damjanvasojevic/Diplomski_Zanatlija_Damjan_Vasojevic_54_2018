import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanatlija_app/data/models/chat.dart';
import 'package:zanatlija_app/data/models/chat_participant.dart';
import 'package:zanatlija_app/data/models/craft.dart';
import 'package:zanatlija_app/data/models/user.dart';
import 'package:zanatlija_app/entities/home/bloc/chat_bloc.dart';
import 'package:zanatlija_app/entities/login/bloc/user_bloc.dart';
import 'package:zanatlija_app/utils/common_widgets.dart';

@RoutePage()
class ViewCraft extends StatefulWidget {
  final Craft craft;
  final bool? isMyJob;
  const ViewCraft(this.craft, {this.isMyJob, super.key});

  @override
  State<ViewCraft> createState() => _ViewCraftState();
}

class _ViewCraftState extends State<ViewCraft> {
  User? _user;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _user = BlocProvider.of<UserBloc>(context).state.user;
      });
    });
    final imageSize = MediaQuery.of(context).size.height * 0.2;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        toolbarHeight: 45,
        actions: [
          if (widget.isMyJob != true && _user?.savedCrafts != null)
            IconButton(
              icon: Icon(
                _user!.savedCrafts!.contains(widget.craft.id)
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                if (_user == null) {
                  return;
                }
                final alreadySaved =
                    _user!.savedCrafts?.contains(widget.craft.id);

                if (alreadySaved == true) {
                  _user!.savedCrafts?.remove(widget.craft.id);
                } else {
                  _user!.savedCrafts?.add(widget.craft.id);
                }

                BlocProvider.of<UserBloc>(context).add(UpdateUserEvent(_user!));
              },
            ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            AutoRouter.of(context).maybePop();
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).cardColor,
        child: Column(
          children: [
            Text(
              widget.craft.craftsmanName,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 32,
                  color: Colors.white),
            ),
            SizedBox(
              height: imageSize / 2,
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: Container(
                      margin: EdgeInsets.only(top: imageSize / 2),
                      child: SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Column(
                            children: [
                              Text(
                                widget.craft.craftName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 28,
                                    color: Colors.black),
                              ),
                              Text(
                                widget.craft.location,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: Color(0xff808080)),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                        border: Border.all(width: 0.5)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.065,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.065,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context)
                                                    .cardColor),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black),
                                              child: const Text(
                                                '€',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Cena po satu:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    color: Color(0xff888888)),
                                              ),
                                              Text(
                                                "${widget.craft.price}€",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 25,
                                                    color: Color(0xff292929)),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                        border: Border.all(width: 0.5)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.065,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.065,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context)
                                                    .cardColor),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Image.asset(
                                                'assets/hammerWrench.png',
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Zanatlija skor:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    color: Color(0xff888888)),
                                              ),
                                              Text(
                                                "${widget.craft.rate?.toStringAsFixed(1) ?? 0.0}/5",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 25,
                                                    color: Color(0xff292929)),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Opis zanata:',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        widget.craft.description,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff808080)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              if (widget.craft.imageUrl != null)
                                Expanded(
                                  child: Image.network(
                                    widget.craft.imageUrl!,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                  ),
                                ),
                              if (widget.isMyJob != true)
                                CommonActionButton(
                                  onAction: () {
                                    final participantOne = ChatParticipant(
                                        username: widget.craft.craftsmanName,
                                        userId: widget.craft.userId);
                                    final participantTwo = ChatParticipant(
                                        username: _user!.nameSurname,
                                        userId: _user!.phoneNumber);
                                    final participants = [
                                      participantOne,
                                      participantTwo,
                                    ];
                                    final participantIds = participants
                                        .map((e) => e.userId)
                                        .toList();
                                    final chat = Chat(
                                      chatNodes: [],
                                      participants: participants,
                                      participantsIds: participantIds,
                                    );

                                    BlocProvider.of<ChatBloc>(context).add(
                                        CreateChatWithUserEvent(
                                            chat, _user!, context));
                                  },
                                  title: 'Kontaktiraj',
                                  customColor: const Color(0xff2B2727),
                                ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0, -1.25),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.isMyJob == true
                              ? Theme.of(context).backgroundColor
                              : Theme.of(context).primaryColorLight,
                          border: Border.all(
                            width: 1,
                          )),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            widget.craft.craftsmanName[0],
                            style: const TextStyle(
                                fontSize: 36, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
