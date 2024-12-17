// ignore_for_file: prefer_const_constructors

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zanatlija_app/data/models/chat.dart';
import 'package:zanatlija_app/data/models/craft.dart';
import 'package:zanatlija_app/data/models/user.dart';
import 'package:zanatlija_app/entities/home/bloc/chat_bloc.dart';
import 'package:zanatlija_app/entities/home/bloc/craft_cubit.dart';
import 'package:zanatlija_app/entities/home/view/widgets/craft_widget.dart';
import 'package:zanatlija_app/entities/login/bloc/user_bloc.dart';
import 'package:zanatlija_app/navigation/router.gr.dart';
import 'package:zanatlija_app/navigation/routes.dart';
import 'package:zanatlija_app/utils/app_mixin.dart';
import 'package:zanatlija_app/utils/common_widgets.dart';
import 'package:zanatlija_app/utils/user_preferences.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AppMixin {
  late User _user;
  @override
  void initState() {
    showLoading(context);
    _user = BlocProvider.of<UserBloc>(context).state.user!;
    Future.delayed(Duration(seconds: 1)).then((value) {
      BlocProvider.of<CraftCubit>(context).getCraftListFromDatabase(_user);
      BlocProvider.of<ChatBloc>(context).add(GetChatsForUserEvent(_user));
    });
    super.initState();
  }

  int _currentIndex = 1;
  List<Craft> _craftList = [];
  List<Chat> _chatList = [];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  String formatDate(DateTime date) {
    var formatter = DateFormat('EEE, d MMMM y', 'sr_RS');

    return _capitalizeFirstLetterOfEachWord(formatter.format(date));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex != 1
          ? null
          : AppBar(
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_month_sharp),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    formatDate(DateTime.now()),
                    style: TextStyle(
                      color: Color(0xff515151),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_outlined),
                  onPressed: () {
                    // ThemeManager().toggleTheme();
                  },
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Poruke',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Početna',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        backgroundColor: Theme.of(context).backgroundColor,
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).focusColor,
        unselectedItemColor: Theme.of(context).disabledColor,
        enableFeedback: false,
        onTap: onTabTapped,
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).cardColor,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
                    padding: EdgeInsets.all(32),
                    child: Image.asset(
                      'assets/hammerWrench.png',
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.height * 0.15,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Dodaj zanat',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      // Close the drawer
                      Navigator.pop(context);
                      AutoRouter.of(context).pushNamed(kAddCraftRoute);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Posalji predlog',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      // Close the drawer
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: const Text(
                'Izloguj se',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                await UserPreferences.instance.clearCredentials();
                AutoRouter.of(context).replaceNamed(kLoginRoute);
              },
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).backgroundColor,
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            _user = state.user!;
            return BlocListener<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChattStateError) {
                  showSnackbarWithTitle(state.error, context);
                } else if (state is GetAllChatsForUserSuccess) {
                  _chatList = state.chats;
                } else if (state is GetByIdSuccess) {
                  setState(() {
                    if (_chatList
                        .any((element) => element.id == state.chat.id)) {
                      return;
                    }
                    _chatList.add(state.chat);
                  });
                }
              },
              child: BlocListener<CraftCubit, CraftState>(
                listener: (context, state) {
                  if (state is CraftStateError) {
                    showSnackbarWithTitle(state.error, context);
                    hideLoading(context);
                  } else if (state is CraftDownloadSuccess) {
                    _craftList.clear();
                    setState(() {
                      _craftList = state.crafts;
                    });
                    hideLoading(context);
                  } else if (state is CrafDeleteStateSuccess) {
                    hideLoading(context);
                  }
                },
                child: _currentIndex == 0
                    ? _Chats()
                    : _currentIndex == 1
                        ? _Home(_user, _craftList)
                        : _currentIndex == 2
                            ? _MyProfile(_user, _craftList)
                            : SizedBox(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Home extends StatefulWidget {
  final User user;
  final List<Craft> crafts;

  const _Home(this.user, this.crafts, {super.key});

  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> with AppMixin {
  final TextEditingController _searchController = TextEditingController();
  List<Craft> _filteredCrafts = [];

  @override
  void initState() {
    super.initState();
    _filteredCrafts = widget.crafts;
    _searchController.addListener(_filterCrafts);
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose of the controller
    super.dispose();
  }

  void _filterCrafts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCrafts = widget.crafts;
      } else {
        _filteredCrafts = widget.crafts.where((craft) {
          return craft.craftName.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _sortCrafts(String criterion) {
    setState(() {
      if (criterion == 'location') {
        _filteredCrafts.sort((a, b) => a.location.compareTo(b.location));
      } else if (criterion == 'price') {
        _filteredCrafts.sort((a, b) => a.price.compareTo(b.price));
      } else if (criterion == 'craftName') {
        _filteredCrafts.sort((a, b) => a.craftName.compareTo(b.craftName));
      } else if (criterion == 'rate') {
        _filteredCrafts.sort((a, b) =>
            (b.rate ?? 0).compareTo(a.rate ?? 0)); // Sort by rate descending
      }
    });
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sortiraj po:'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Lokaciji'),
                onTap: () {
                  _sortCrafts('location');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Ceni'),
                onTap: () {
                  _sortCrafts('price');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Kategoriji zanata'),
                onTap: () {
                  _sortCrafts('craftName');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Skoru'),
                onTap: () {
                  _sortCrafts('rate');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final listToShow =
        _filteredCrafts.isEmpty ? widget.crafts : _filteredCrafts;
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                  child: CommonTextField('Pretrazi zanate', _searchController)),
              IconButton(
                onPressed: _showSortDialog,
                icon: Icon(Icons.sort),
              ),
            ],
          ),
          SizedBox(height: 15),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Lista zanata',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1E1E1E)),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).cardColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        showLoading(context);
                        BlocProvider.of<CraftCubit>(context)
                            .getCraftListFromDatabase(
                                BlocProvider.of<UserBloc>(context).state.user!);
                      },
                      icon: Icon(Icons.refresh)),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: listToShow.isNotEmpty
                  ? SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: listToShow.map((craft) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CraftWidget(
                              craft,
                              fullSize: true,
                              isMyJob: craft.userId == widget.user.phoneNumber,
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.235,
                      child: Center(
                        child: Text('Lista je prazna'),
                      ),
                    ),
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}

class _MyProfile extends StatelessWidget {
  final User user;
  final List<Craft> crafts;
  const _MyProfile(this.user, this.crafts, {super.key});

  @override
  Widget build(BuildContext context) {
    final myJobs =
        crafts.where((element) => element.userId == user.phoneNumber).toList();
    final savedJobs = crafts
        .where((e) =>
            user.savedCrafts!.any((savedElement) => e.id == savedElement))
        .toList();
    final imageSize = MediaQuery.of(context).size.height * 0.2;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Text(
                'Moj profil',
                style: TextStyle(
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
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: Container(
                        margin: EdgeInsets.only(top: imageSize / 2),
                        child: Column(
                          children: [
                            Text(
                              user.nameSurname,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 28,
                                  color: Colors.black),
                            ),
                            Text(
                              user.location,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Color(0xff808080)),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Moji poslovi',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 24,
                                                  color: Color(0xff1E1E1E)),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(4),
                                              child: myJobs.isNotEmpty
                                                  ? SingleChildScrollView(
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        children: [
                                                          for (final item
                                                              in myJobs)
                                                            CraftWidget(
                                                              item,
                                                              isMyJob: true,
                                                            )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.235,
                                                      child: Center(
                                                          child: Text(
                                                              'Lista je prazna')),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Sačuvani zanati',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 24,
                                                  color: Color(0xff1E1E1E)),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(4),
                                              child: savedJobs.isNotEmpty
                                                  ? SingleChildScrollView(
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        children: [
                                                          for (final item
                                                              in savedJobs)
                                                            CraftWidget(item)
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.235,
                                                      child: Center(
                                                        child: Text(
                                                            'Lista je prazna'),
                                                      ),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0, -1.35),
                      child: user.imageUrl != null
                          ? CircleAvatar(
                              radius:
                                  (MediaQuery.of(context).size.height * 0.2) /
                                      2,
                              backgroundImage: NetworkImage(user.imageUrl!),
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                            )
                          : Image.asset(
                              'assets/userProfileFill.png',
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chats extends StatefulWidget {
  @override
  State<_Chats> createState() => _ChatsState();
}

class _ChatsState extends State<_Chats> with AppMixin {
  List<Chat> _chats = [];

  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  void _fetchChats() {
    hideLoading(context);
    BlocProvider.of<ChatBloc>(context).add(
      GetChatsForUserEvent(BlocProvider.of<UserBloc>(context).state.user!),
    );
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChattStateError) {
          showSnackbarWithTitle(state.error, context);
          hideLoading(context);
        } else if (state is ChatLoadingState) {}
        if (state is GetAllChatsForUserSuccess) {
          setState(() {
            _chats = state.chats;

            try {
              _chats.sort(
                (a, b) => DateTime.fromMillisecondsSinceEpoch(
                        b.chatNodes.last.timeStampInMillis)
                    .compareTo(
                  DateTime.fromMillisecondsSinceEpoch(
                      a.chatNodes.last.timeStampInMillis),
                ),
              );
              hideLoading(context);
            } catch (e) {}
          });
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  'Poruke',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 28,
                      color: Colors.black),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    // Fetch chats again when the user pulls to refresh
                    _fetchChats();
                  },
                  child: _chats.isEmpty
                      ? Center(child: Text('Nema trenutnih poruka'))
                      : ListView.builder(
                          itemCount: _chats.length,
                          itemBuilder: (context, index) {
                            final myMessage =
                                _chats[index].chatNodes.last.userId ==
                                    BlocProvider.of<UserBloc>(context)
                                        .state
                                        .user!
                                        .phoneNumber;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                  onTap: () async {
                                    await AutoRouter.of(context).push(
                                      ChatRoom(chat: _chats[index]),
                                    );
                                    _fetchChats();
                                  },
                                  isThreeLine: true,
                                  leading: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: myMessage
                                            ? Theme.of(context).backgroundColor
                                            : Theme.of(context)
                                                .primaryColorLight,
                                        border: Border.all(
                                          width: 1,
                                        )),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text(_chats[index]
                                          .chatNodes
                                          .last
                                          .senderUsername[0]),
                                    ),
                                  ),
                                  title: Text(
                                    myMessage
                                        ? 'Ja'
                                        : _chats[index].chatNodes.isNotEmpty
                                            ? _chats[index]
                                                .chatNodes
                                                .last
                                                .senderUsername
                                            : '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _chats[index].chatNodes.isNotEmpty
                                            ? _chats[index]
                                                .chatNodes
                                                .last
                                                .message
                                            : '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff292929),
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        _chats[index].chatNodes.isNotEmpty
                                            ? formatTimestamp(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    _chats[index]
                                                        .chatNodes
                                                        .last
                                                        .timeStampInMillis))
                                            : '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context).cardColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
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
