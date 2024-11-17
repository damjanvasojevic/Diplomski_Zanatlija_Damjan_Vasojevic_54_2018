import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

mixin AppMixin<T extends StatefulWidget> {
  Future<void>? _dialogFuture;

  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  Future<void> wait(Duration duration) async {
    await Future.delayed(duration);
  }

  void showSnackbarWithTitle(String title, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
  }

  void showLoadingDialog(BuildContext context) {
    _dialogFuture = showDialog(
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

  void hideLoadingDialog(BuildContext context) {
    if (_dialogFuture != null) {
      Navigator.of(context).pop();
      _dialogFuture = null;
    }
  }

  String getHashedPassword(String text) {
    final bytes = utf8.encode(text);
    final digest = sha256.convert(bytes);
    return digest.toString();
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
