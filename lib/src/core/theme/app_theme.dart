import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color primaryGreen = Color(0xFF0E7A4F);
  static const Color deepGreen = Color(0xFF075E3D);
  static const Color softGreen = Color(0xFFEAF7F0);
  static const Color mintGreen = Color(0xFFDFF5EA);
  static const Color appleGreen = Color(0xFF34C759);

  static const Color primaryBlue = primaryGreen;
  static const Color darkBlue = deepGreen;
  static const Color softBlue = softGreen;

  static const Color redAccent = Color(0xFFD92D20);
  static const Color amberAccent = Color(0xFFF79009);

  static const Color textDark = Color(0xFF101828);
  static const Color textMuted = Color(0xFF667085);
  static const Color textSoft = Color(0xFF8A94A6);

  static const Color border = Color(0xFFE5E7EB);
  static const Color borderStrong = Color(0xFFD0D5DD);
  static const Color background = Color(0xFFF7FAF8);
  static const Color card = Colors.white;

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.light,
      primary: primaryGreen,
      secondary: appleGreen,
      surface: card,
      error: redAccent,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: colorScheme,
      visualDensity: VisualDensity.standard,

      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: background,
        foregroundColor: textDark,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.2,
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: softGreen,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: primaryGreen,
              size: 25,
            );
          }

          return const IconThemeData(
            color: textMuted,
            size: 24,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: primaryGreen,
              fontSize: 11.5,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.1,
            );
          }

          return const TextStyle(
            color: textMuted,
            fontSize: 11.2,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.1,
          );
        }),
      ),

      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: border),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          side: const BorderSide(color: borderStrong),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        hintStyle: const TextStyle(
          color: textSoft,
          fontWeight: FontWeight.w600,
        ),
        labelStyle: const TextStyle(
          color: textMuted,
          fontWeight: FontWeight.w700,
        ),
        prefixIconColor: textMuted,
        suffixIconColor: textMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(
            color: primaryGreen,
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(
            color: redAccent,
            width: 1.4,
          ),
        ),
      ),

      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(color: border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(
              color: primaryGreen,
              width: 1.4,
            ),
          ),
        ),
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
          fontSize: 31,
          fontWeight: FontWeight.w900,
          color: textDark,
          height: 1.06,
          letterSpacing: -0.7,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: textDark,
          height: 1.12,
          letterSpacing: -0.35,
        ),
        titleLarge: TextStyle(
          fontSize: 17.5,
          fontWeight: FontWeight.w900,
          color: textDark,
          height: 1.18,
          letterSpacing: -0.25,
        ),
        titleMedium: TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w800,
          color: textDark,
          height: 1.22,
          letterSpacing: -0.15,
        ),
        bodyLarge: TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w600,
          color: textDark,
          height: 1.35,
          letterSpacing: -0.05,
        ),
        bodyMedium: TextStyle(
          fontSize: 13.4,
          fontWeight: FontWeight.w600,
          color: textMuted,
          height: 1.35,
          letterSpacing: -0.05,
        ),
        bodySmall: TextStyle(
          fontSize: 12.2,
          fontWeight: FontWeight.w600,
          color: textMuted,
          height: 1.3,
        ),
      ),
    );
  }

  static List<BoxShadow> get softShadow {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.045),
        blurRadius: 24,
        offset: const Offset(0, 12),
      ),
    ];
  }

  static List<BoxShadow> get greenShadow {
    return [
      BoxShadow(
        color: primaryGreen.withValues(alpha: 0.16),
        blurRadius: 28,
        offset: const Offset(0, 14),
      ),
    ];
  }
}
