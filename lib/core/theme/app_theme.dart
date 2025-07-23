import 'package:flutter/material.dart';
import 'app_fonts.dart';

final ThemeData appTheme = ThemeData(
  fontFamily: 'Viga',
  primaryColor: const Color(0xFFd1fc3e),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFd1fc3e),
    primary: const Color(0xFFd1fc3e),
    secondary: const Color(0xFF2d2c2f),
  ),
  scaffoldBackgroundColor: const Color(0xFF1d1d1e),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xFFd1fc3e),
    selectionColor: Color(0xFFd1fc3e),
    selectionHandleColor: Color(0xFFd1fc3e),
  ),
  textTheme: TextTheme(
    headlineLarge: AppFonts.heading,
    titleLarge: AppFonts.headingBlack,
    bodyMedium: AppFonts.body,
    labelSmall: AppFonts.label,
    headlineMedium: AppFonts.headingMedium,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFd1fc3e)),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFd1fc3e), width: 2.0),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFd1fc3e),
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  ),
  iconTheme: IconThemeData(color: Color(0xFF505050)),
  useMaterial3: true,
);
