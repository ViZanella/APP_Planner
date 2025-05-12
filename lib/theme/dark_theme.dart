import 'package:flutter/material.dart';

class AppDarkColors {
  static const eerieBlack = Color(0xFF26140C);
  static const morocco = Color(0xFF492617);
  static const newAmber = Color(0xFF713B24);
  static const coconut = Color(0xFF944E2F);
  static const smokeTree = Color(0xFFB7603A);
}

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppDarkColors.eerieBlack,
  scaffoldBackgroundColor: AppDarkColors.morocco,
  appBarTheme: AppBarTheme(
    backgroundColor: AppDarkColors.newAmber,
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.dark(
    primary: AppDarkColors.eerieBlack,
    secondary: AppDarkColors.smokeTree,
  ),
);
