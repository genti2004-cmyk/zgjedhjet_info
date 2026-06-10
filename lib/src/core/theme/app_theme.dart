import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF0B4EA2);
  static const Color darkBlue = Color(0xFF073B7A);
  static const Color softBlue = Color(0xFFEAF2FF);
  static const Color redAccent = Color(0xFFD62828);
  static const Color textDark = Color(0xFF101828);
  static const Color textMuted = Color(0xFF667085);
  static const Color border = Color(0xFFE4E7EC);
  static const Color background = Color(0xFFF7F9FC);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: redAccent,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: textDark,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: border),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w900,
          color: textDark,
          height: 1.08,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: textDark,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: textDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w500,
          color: textDark,
          height: 1.35,
        ),
        bodyMedium: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
          color: textMuted,
          height: 1.35,
        ),
      ),
    );
  }
}