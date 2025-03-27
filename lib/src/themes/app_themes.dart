import 'package:flutter/material.dart';

class AppColors {
  // Global colors
  static const Color background = Color(0xFF2A2A40);
  static const Color primary = Color(0xFFEDEDED);
  static const Color secondary = Color(0xFFB0B0B0);
  static const Color borders = Color(0xFF4A4E5A);
  static const Color accent = Color(0xFF1E88E5);
  static const Color accentAlt = Color(0xFF39D39F);
  static const Color success = Color(0xFF66BB6A);
  static const Color error = Color(0xFFEF5350);
}

class AppThemes {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      
      // Color schemes
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.background,
        error: AppColors.error,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),

      // Text
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: AppColors.primary),
      ),

      // Dividers
      dividerTheme: DividerThemeData(
        color: AppColors.borders,
        thickness: 1,
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.borders),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.borders),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.accent),
        ),
      ),

      // Cards
      cardTheme: CardTheme(
        color: AppColors.background,
        elevation: 4,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.borders),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}