import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);

  // Neue neutrale Wahl-App-Farbwelt.
  static const Color primaryNavy = Color(0xFF102A43);
  static const Color deepNavy = Color(0xFF071A2D);
  static const Color accentBlue = Color(0xFF1559A8);
  static const Color accentTurquoise = Color(0xFF087F78);
  static const Color winnerGold = Color(0xFFD6A84B);
  static const Color softNavy = Color(0xFFEAF2FF);

  // Kompatibilitäts-Aliase für bestehende Widgets.
  static const Color primaryGreen = primaryNavy;
  static const Color deepGreen = deepNavy;
  static const Color mediumGreen = accentBlue;
  static const Color softGreen = softNavy;
  static const Color primaryBlue = accentBlue;
  static const Color softBlue = softNavy;
  static const Color redAccent = Color(0xFFE5484D);

  static const Color textDark = Color(0xFF172B4D);
  static const Color textMuted = Color(0xFF66788A);

  static const Color border = Color(0xFFE1E7EF);
  static const Color borderStrong = Color(0xFFC7D2E1);

  static const Color warningBackground = Color(0xFFFFFBEB);
  static const Color warningBorder = Color(0xFFFEDC7A);
  static const Color warningText = Color(0xFF7A4B00);
  static const Color warningIcon = Color(0xFFB54708);

  static const Color successBackground = Color(0xFFE8F7F6);
  static const Color successBorder = Color(0xFF9EDFD8);
  static const Color successText = Color(0xFF087F78);
  static const Color successIcon = Color(0xFF087F78);

  static List<BoxShadow> get navyShadow => [
        BoxShadow(
          color: primaryNavy.withValues(alpha: 0.20),
          blurRadius: 26,
          offset: const Offset(0, 14),
        ),
      ];

  static List<BoxShadow> get greenShadow => navyShadow;

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.055),
          blurRadius: 22,
          offset: const Offset(0, 10),
        ),
      ];

  static ThemeData get theme => lightTheme;

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.light,
      primary: primaryGreen,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto',
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: background,
        foregroundColor: textDark,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        prefixIconColor: textMuted,
        suffixIconColor: textMuted,
        labelStyle: const TextStyle(
          color: textMuted,
          fontWeight: FontWeight.w700,
        ),
        hintStyle: const TextStyle(
          color: textMuted,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: primaryGreen,
            width: 1.4,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 13,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          side: const BorderSide(color: borderStrong),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 13,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 13,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: softGreen,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryGreen, size: 23);
          }

          return const IconThemeData(color: textMuted, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: primaryGreen,
              fontSize: 9.6,
              fontWeight: FontWeight.w900,
            );
          }

          return const TextStyle(
            color: textMuted,
            fontSize: 9.4,
            fontWeight: FontWeight.w700,
          );
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textDark,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textDark,
          fontSize: 25,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
          height: 1.1,
        ),
        headlineMedium: TextStyle(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.35,
          height: 1.15,
        ),
        titleLarge: TextStyle(
          color: textDark,
          fontSize: 16,
          fontWeight: FontWeight.w900,
          height: 1.2,
        ),
        titleMedium: TextStyle(
          color: textDark,
          fontSize: 14,
          fontWeight: FontWeight.w800,
          height: 1.25,
        ),
        bodyLarge: TextStyle(
          color: textDark,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.35,
        ),
        bodyMedium: TextStyle(
          color: textMuted,
          fontSize: 12.8,
          fontWeight: FontWeight.w600,
          height: 1.35,
        ),
        labelLarge: TextStyle(
          color: textDark,
          fontSize: 13,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
