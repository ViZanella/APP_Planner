import 'package:flutter/material.dart';

class AppLightColors {
  static const coffee = Color(0xFF452815);
  static const peru = Color(0xFF73411F);
  static const barleyCorn = Color(0xFFB6885D);
  static const raffia = Color(0xFFE0C4A0);
  static const champagne = Color(0xFFE8D288);
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppLightColors.coffee,
  scaffoldBackgroundColor: AppLightColors.champagne,
  appBarTheme: AppBarTheme(
    backgroundColor: AppLightColors.peru,
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.light(
    primary: AppLightColors.coffee,
    secondary: AppLightColors.barleyCorn,
  ),
);
