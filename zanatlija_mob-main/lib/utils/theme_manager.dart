import 'package:flutter/material.dart';
import 'package:zanatlija_app/utils/theme.dart';

class ThemeManager {
  static final ThemeManager _instance = ThemeManager._internal();
  factory ThemeManager() => _instance;

  ThemeManager._internal();

  final ValueNotifier<ThemeData> themeNotifier = ValueNotifier(lightTheme);

  void toggleTheme() {
    themeNotifier.value =
        (themeNotifier.value == lightTheme) ? darkTheme : lightTheme;
  }
}
