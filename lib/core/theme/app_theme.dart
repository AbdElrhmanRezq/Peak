import 'package:flutter/material.dart';
import 'app_fonts.dart';

final ThemeData appTheme = ThemeData(
  fontFamily: 'Viga',
  textTheme: TextTheme(
    headlineLarge: AppFonts.heading,
    titleLarge: AppFonts.headingBlack,
    bodyMedium: AppFonts.body,
    labelSmall: AppFonts.label,
  ),
  primaryColor: const Color(0xFFE6FE58), // Using the hex color from consts.dart
  useMaterial3: true,
);
