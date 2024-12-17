import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanatlija_app/utils/cubit/loading_cubit.dart';

mixin AppMixin<T extends StatefulWidget> {
  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  Future<void> wait(Duration duration) async {
    await Future.delayed(duration);
  }

  void showSnackbarWithTitle(String title, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
  }

  String getHashedPassword(String text) {
    final bytes = utf8.encode(text);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void showLoading(BuildContext context) {
    BlocProvider.of<LoadingCubit>(context).showLoading();
  }

  void hideLoading(BuildContext context) {
    BlocProvider.of<LoadingCubit>(context).hideLoading();
  }

  Widget animatedChildSwitcher({
    required Widget currentChild,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final tween = Tween(begin: 0.0, end: 1.0);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );
        final opacityAnimation = tween.animate(curvedAnimation);

        return FadeTransition(
          opacity: opacityAnimation,
          child: child,
        );
      },
      child: currentChild,
    );
  }
}
