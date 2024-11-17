import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zanatlija_app/data/models/craft.dart';
import 'package:zanatlija_app/data/models/user.dart';
import 'package:zanatlija_app/data/services/firestore_service.dart';
import 'package:zanatlija_app/data/services/storage_service.dart';

part 'craft_state.dart';

class CraftCubit extends Cubit<CraftState> {
  final FirestoreService firestoreService;
  final StorageService storageService;
  CraftCubit(
    this.firestoreService,
    this.storageService,
  ) : super(CraftInitial());

  Future<void> getCraftListFromDatabase(User user) async {
    emit(CraftLoadingState());
    try {
      final crafts = await firestoreService.getAllCrafts(user);

      emit(CraftDownloadSuccess(crafts));
    } catch (e) {
      emit(CraftStateError(e.toString()));
    }
  }

  Future<String?> uploadAndGetImageUrl(File file) async {
    emit(CraftLoadingState());
    try {
      final image = await storageService.uploadImage(file);
      if (image == null) {
        emit(const CraftUploadErrorState('Error uploading image to storage'));
        throw 'Error in uploading image';
      }
      emit(CrafStateSuccess());
      return image;
    } catch (e) {
      emit(CraftStateError(e.toString()));
      return null;
    }
  }

  Future<void> addNewJob(Craft craft, User user) async {
    emit(CraftLoadingState());
    try {
      await firestoreService.addCraft(craft, user);
      emit(CrafAddNewJobSuccess());
    } catch (e) {
      debugPrint('Error $e');
      emit(CrafAddNewJobError(e.toString()));
    }
  }
}
