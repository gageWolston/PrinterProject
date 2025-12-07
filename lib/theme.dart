import 'package:flutter/material.dart';

/// Central palette for the entire app.
///
/// Update the colors below to quickly reskin the application.
class AppPalette {
  static const Color primary = Color(0xFF2D6A4F);
  static const Color secondary = Color(0xFF1D3557);
  static const Color accent = Color(0xFFF77F00);
  static const Color surface = Color(0xFFF7F8FA);
}

class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppPalette.primary,
      primary: AppPalette.primary,
      secondary: AppPalette.secondary,
      tertiary: AppPalette.accent,
      surface: AppPalette.surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppPalette.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.primary,
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}
