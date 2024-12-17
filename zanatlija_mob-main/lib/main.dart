import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zanatlija_app/data/services/firestore_service.dart';
import 'package:zanatlija_app/data/services/storage_service.dart';
import 'package:zanatlija_app/entities/home/bloc/chat_bloc.dart';
import 'package:zanatlija_app/entities/home/bloc/craft_cubit.dart';
import 'package:zanatlija_app/entities/login/bloc/user_bloc.dart';
import 'package:zanatlija_app/utils/cubit/loading_cubit.dart';
import 'package:zanatlija_app/utils/user_preferences.dart';
import 'package:zanatlija_app/zanatlija.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<LoadingCubit>(() => LoadingCubit());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyClEwWIs01DXcSywtFRM-Zk4WePTbFD6ws",
      appId: "1:737907302079:android:97a20ad7ab1e4fda0e700a",
      messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
      projectId: "zanatlija-6431f",
      storageBucket: 'zanatlija-6431f.appspot.com',
    ),
  );
  await initializeDateFormatting('sr_RS', null);
  await UserPreferences.instance.init();
  final StorageService storageService = StorageService();
  final FirestoreService firestoreService = FirestoreService();

  setupLocator();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<UserBloc>(create: (_) => UserBloc(firestoreService)),
      BlocProvider<ChatBloc>(create: (_) => ChatBloc(firestoreService)),
      BlocProvider<CraftCubit>(
        create: (_) => CraftCubit(
          firestoreService,
          storageService,
        ),
      ),
      BlocProvider(
        create: (_) => LoadingCubit(),
      ),
    ],
    child: const ZanatlijaApp(),
  ));
}
