// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanatlija_app/data/services/firestore_service.dart';
import 'package:zanatlija_app/data/models/user.dart';
import 'package:zanatlija_app/navigation/routes.dart';
import 'package:zanatlija_app/utils/user_preferences.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirestoreService service;
  StreamSubscription? _firebaseStateChangedSubscription;

  UserBloc(this.service) : super(const UserState()) {
    on<CreateUserEvent>(_createUser);
    on<LoginUserEvent>(_loginUser);
    on<UpdateUserEvent>(_updateUser);
    on<NotifyUserEvent>(_notifyUser);
    on<AutoLoginUserEvent>(_autoLoginUser);
  }
  @override
  Future<void> close() {
    _firebaseStateChangedSubscription?.cancel();
    return super.close();
  }

  Future<void> _updateUser(
      UpdateUserEvent event, Emitter<UserState> emit) async {
    try {
      await service.updateFirestoreUser(event.user);
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  Future<void> _notifyUser(
      NotifyUserEvent event, Emitter<UserState> emit) async {
    final newState = state.copyWith(user: event.user);
    emit(newState);
  }

  Future<void> _createUser(
      CreateUserEvent event, Emitter<UserState> emit) async {
    try {
      await service.createUser(event.user);
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  Future<void> _autoLoginUser(
      AutoLoginUserEvent event, Emitter<UserState> emit) async {
    try {
      final user = await service.autologin(event.phoneNumber, event.password);
      final newState = state.copyWith(user: user);
      emit(newState);

      _firebaseStateChangedSubscription = service.getUserCollectionReference
          .doc(user.phoneNumber)
          .snapshots()
          .listen(_onFireBaseStateChanged);
      await UserPreferences.instance
          .saveUserCredentials(user.phoneNumber, user.password);
      AutoRouter.of(event.context).replaceNamed(kHomeRoute);
    } catch (loginError) {
      ScaffoldMessenger.of(event.context)
          .showSnackBar(const SnackBar(content: Text('Doslo je do greske')));
      AutoRouter.of(event.context).replaceNamed(kLoginRoute);
    }
  }

  Future<void> _loginUser(LoginUserEvent event, Emitter<UserState> emit) async {
    try {
      final user = await service.login(event.phoneNumber, event.password);
      if (user != null) {
        final newState = state.copyWith(user: user);
        emit(newState);

        _firebaseStateChangedSubscription = service.getUserCollectionReference
            .doc(user.phoneNumber)
            .snapshots()
            .listen(_onFireBaseStateChanged);
        await UserPreferences.instance
            .saveUserCredentials(user.phoneNumber, user.password);
        AutoRouter.of(event.context).replaceNamed(kHomeRoute);
        return;
      }
      AutoRouter.of(event.context).replaceNamed(kHomeRoute);
    } catch (loginError) {
      if (loginError == LoginError.userNotFound) {
        ScaffoldMessenger.of(event.context).showSnackBar(
            const SnackBar(content: Text('Uneli ste pogresan broj telefona')));
      } else if (loginError == LoginError.passwordIsWrong) {
        ScaffoldMessenger.of(event.context).showSnackBar(
            const SnackBar(content: Text('Uneli ste pogresnu sifru')));
      } else if (loginError == LoginError.unknownError) {
        ScaffoldMessenger.of(event.context).showSnackBar(const SnackBar(
            content: Text('Nepoznata greska prilikom loginovanja')));
      }
    }
  }

  Future<void> _onFireBaseStateChanged(
      DocumentSnapshot<Object?> snapshot) async {
    final data = User.fromJson(snapshot.data() as Map<String, dynamic>);
    add(NotifyUserEvent(data));
  }
}
