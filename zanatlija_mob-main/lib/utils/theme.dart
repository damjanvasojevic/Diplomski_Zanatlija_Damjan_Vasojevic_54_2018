import 'package:flutter/material.dart';

const String fontFamily = 'Montserrat';
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xff2E36FF),
  primaryColorDark: const Color(0xff2E36FF),
  primaryColorLight: const Color(0xffFF9F2E),
  backgroundColor: const Color(0xffF3F3F3),
  disabledColor: Color(0xff888888),
  focusColor: Colors.black,
  cardColor: const Color(0xff226060),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontFamily: fontFamily),
    bodyMedium: TextStyle(fontFamily: fontFamily),
    displayLarge: TextStyle(fontFamily: fontFamily),
    displayMedium: TextStyle(fontFamily: fontFamily),
    // Add other text styles as needed
  ),
  bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xff888888)),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xff2E36FF),
  primaryColorDark: const Color(0xff2E36FF),
  primaryColorLight: const Color(0xffFF9F2E),
  cardColor: Color(0xff49A7A7),
  backgroundColor: Color(0xff282928),
  disabledColor: Color(0xff49A7A7),
  focusColor: Colors.white,
);
