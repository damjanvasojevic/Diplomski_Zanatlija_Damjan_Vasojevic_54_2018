// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i11;
import 'package:zanatlija_app/data/models/chat.dart' as _i10;
import 'package:zanatlija_app/data/models/craft.dart' as _i12;
import 'package:zanatlija_app/entities/home/view/add_craft_screen.dart' as _i1;
import 'package:zanatlija_app/entities/home/view/chat_room_screen.dart' as _i2;
import 'package:zanatlija_app/entities/home/view/home_screen.dart' as _i3;
import 'package:zanatlija_app/entities/home/view/view_craft_screen.dart' as _i8;
import 'package:zanatlija_app/entities/initial/view/initial_page_screen.dart'
    as _i4;
import 'package:zanatlija_app/entities/login/view/login_screen.dart' as _i5;
import 'package:zanatlija_app/entities/login/view/registration_screen.dart'
    as _i7;
import 'package:zanatlija_app/entities/messages/view/messages_screen.dart'
    as _i6;

abstract class $AppRouter extends _i9.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    AddCraft.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AddCraft(),
      );
    },
    ChatRoom.name: (routeData) {
      final args = routeData.argsAs<ChatRoomArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.ChatRoom(
          args.chat,
          key: args.key,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.HomePage(),
      );
    },
    InitialRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.InitialPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.LoginPage(),
      );
    },
    MessagesRoute.name: (routeData) {
      final args = routeData.argsAs<MessagesRouteArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.MessagesScreen(
          userId: args.userId,
          key: args.key,
        ),
      );
    },
    RegistrationRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.RegistrationPage(),
      );
    },
    ViewCraft.name: (routeData) {
      final args = routeData.argsAs<ViewCraftArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.ViewCraft(
          args.craft,
          isMyJob: args.isMyJob,
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AddCraft]
class AddCraft extends _i9.PageRouteInfo<void> {
  const AddCraft({List<_i9.PageRouteInfo>? children})
      : super(
          AddCraft.name,
          initialChildren: children,
        );

  static const String name = 'AddCraft';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ChatRoom]
class ChatRoom extends _i9.PageRouteInfo<ChatRoomArgs> {
  ChatRoom({
    required _i10.Chat chat,
    _i11.Key? key,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          ChatRoom.name,
          args: ChatRoomArgs(
            chat: chat,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ChatRoom';

  static const _i9.PageInfo<ChatRoomArgs> page =
      _i9.PageInfo<ChatRoomArgs>(name);
}

class ChatRoomArgs {
  const ChatRoomArgs({
    required this.chat,
    this.key,
  });

  final _i10.Chat chat;

  final _i11.Key? key;

  @override
  String toString() {
    return 'ChatRoomArgs{chat: $chat, key: $key}';
  }
}

/// generated route for
/// [_i3.HomePage]
class HomeRoute extends _i9.PageRouteInfo<void> {
  const HomeRoute({List<_i9.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i4.InitialPage]
class InitialRoute extends _i9.PageRouteInfo<void> {
  const InitialRoute({List<_i9.PageRouteInfo>? children})
      : super(
          InitialRoute.name,
          initialChildren: children,
        );

  static const String name = 'InitialRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i5.LoginPage]
class LoginRoute extends _i9.PageRouteInfo<void> {
  const LoginRoute({List<_i9.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i6.MessagesScreen]
class MessagesRoute extends _i9.PageRouteInfo<MessagesRouteArgs> {
  MessagesRoute({
    required String userId,
    _i11.Key? key,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          MessagesRoute.name,
          args: MessagesRouteArgs(
            userId: userId,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'MessagesRoute';

  static const _i9.PageInfo<MessagesRouteArgs> page =
      _i9.PageInfo<MessagesRouteArgs>(name);
}

class MessagesRouteArgs {
  const MessagesRouteArgs({
    required this.userId,
    this.key,
  });

  final String userId;

  final _i11.Key? key;

  @override
  String toString() {
    return 'MessagesRouteArgs{userId: $userId, key: $key}';
  }
}

/// generated route for
/// [_i7.RegistrationPage]
class RegistrationRoute extends _i9.PageRouteInfo<void> {
  const RegistrationRoute({List<_i9.PageRouteInfo>? children})
      : super(
          RegistrationRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegistrationRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i8.ViewCraft]
class ViewCraft extends _i9.PageRouteInfo<ViewCraftArgs> {
  ViewCraft({
    required _i12.Craft craft,
    bool? isMyJob,
    _i11.Key? key,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          ViewCraft.name,
          args: ViewCraftArgs(
            craft: craft,
            isMyJob: isMyJob,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ViewCraft';

  static const _i9.PageInfo<ViewCraftArgs> page =
      _i9.PageInfo<ViewCraftArgs>(name);
}

class ViewCraftArgs {
  const ViewCraftArgs({
    required this.craft,
    this.isMyJob,
    this.key,
  });

  final _i12.Craft craft;

  final bool? isMyJob;

  final _i11.Key? key;

  @override
  String toString() {
    return 'ViewCraftArgs{craft: $craft, isMyJob: $isMyJob, key: $key}';
  }
}
