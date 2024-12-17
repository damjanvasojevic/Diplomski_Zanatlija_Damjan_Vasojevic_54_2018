import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanatlija_app/entities/home/bloc/chat_bloc.dart';
import 'package:zanatlija_app/entities/home/bloc/craft_cubit.dart';
import 'package:zanatlija_app/entities/login/bloc/user_bloc.dart';
import 'package:zanatlija_app/navigation/router.dart';
import 'package:zanatlija_app/utils/app_mixin.dart';
import 'package:zanatlija_app/utils/cubit/loading_cubit.dart';
import 'package:zanatlija_app/utils/theme_manager.dart';

class ZanatlijaApp extends StatefulWidget {
  const ZanatlijaApp({super.key});

  @override
  State<ZanatlijaApp> createState() => _ZanatlijaAppState();
}

class _ZanatlijaAppState extends State<ZanatlijaApp> with AppMixin {
  final AppRouter _appRouter = AppRouter();
  bool _showDialog = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    BlocProvider.of<UserBloc>(context).close();
    BlocProvider.of<CraftCubit>(context).close();
    BlocProvider.of<LoadingCubit>(context).close();
    super.dispose();
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Loading..."),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
        valueListenable: ThemeManager().themeNotifier,
        builder: (context, theme, child) {
          return MaterialApp.router(
              routerDelegate: _appRouter.delegate(),
              routeInformationParser: _appRouter.defaultRouteParser(),
              title: 'Zanatlija',
              debugShowCheckedModeBanner: false,
              theme: theme,
              builder: (context, child) {
                return MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                          value: BlocProvider.of<UserBloc>(context)),
                      BlocProvider.value(
                          value: BlocProvider.of<ChatBloc>(context)),
                      BlocProvider.value(
                          value: BlocProvider.of<CraftCubit>(context)),
                      BlocProvider.value(
                          value: BlocProvider.of<LoadingCubit>(context)),
                    ],
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        child!,
                        BlocListener<LoadingCubit, bool>(
                          child: _showDialog
                              ? CircularProgressIndicator()
                              : SizedBox(),
                          listener: (context, isLoading) {
                            setState(() {
                              _showDialog = isLoading;
                            });
                          },
                        ),
                      ],
                    ));
              });
        });
  }
}
