import 'package:flutter/material.dart';

//AppColors for the dark theme
class AppColors {
  static const Color background = Color(0xFF2A2A40);
  static const Color primary = Color(0xFFEDEDED);
  static const Color secondary = Color(0xFFB0B0B0);
  static const Color borders = Color(0xFF4A4E5A);
  static const Color accent = Color(0xFF1E88E5);
  static const Color accentAlt = Color(0xFF39D39F);
  static const Color success = Color(0xFF66BB6A);
  static const Color error = Color(0xFFEF5350);
}

//AppColors for the light theme
class AppColorsLight {
  static const Color background = Color(0xFFF5F5F5);
  static const Color primary = Color(0xFF333333);
  static const Color secondary = Color(0xFF757575);
  static const Color borders = Color(0xFFE0E0E0);
  static const Color accent = Color(0xFF4A90E2);
  static const Color accentAlt = Color(0xFF48C9B0);
  static const Color success = Color(0xFF81C784);
  static const Color error = Color(0xFFE57373);
}

//Custom color extension
class CustomColors extends ThemeExtension<CustomColors> {
  final Color success;
  final Color borders;
  final Color accent;
  final Color accentAlt;

  const CustomColors({required this.success, required this.borders, required this.accent, required this.accentAlt});

  @override
  CustomColors copyWith({Color? success, Color? borders, Color? accent, Color? accentAlt}) {
    return CustomColors(
      success: success ?? this.success,
      borders: borders ?? this.borders,
      accent: accent ?? this.accent,
      accentAlt: accentAlt ?? this.accentAlt,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      success: Color.lerp(success, other.success, t)!,
      borders: Color.lerp(borders, other.borders, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentAlt: Color.lerp(accentAlt, other.accentAlt, t)!,
    );
  }

  // Factory for dark theme
  static final CustomColors dark = CustomColors(
    success: AppColors.success,
    borders: AppColors.borders,
    accent: AppColors.accent,
    accentAlt: AppColors.accentAlt,
  );

  // Factory for light theme
  static final CustomColors light = CustomColors(
    success: AppColorsLight.success,
    borders: AppColorsLight.borders,
    accent: AppColorsLight.accent,
    accentAlt: AppColorsLight.accentAlt,
  );
}

//AppThemes that configure the dark and light themes
class AppThemes {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,

      // Color schemes
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.background,
      ),

      // Add custom colors extension
      extensions: [CustomColors.dark],

      // AppBar
      appBarTheme: AppBarTheme(backgroundColor: AppColors.background, foregroundColor: AppColors.primary, elevation: 0),

      // Text
      textTheme: TextTheme(bodyMedium: TextStyle(color: AppColors.primary)),

      // Dividers
      dividerTheme: DividerThemeData(color: AppColors.borders, thickness: 1),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.white),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.borders)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.borders)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.accent)),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.background,
        elevation: 4,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.borders),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColorsLight.primary,
        secondary: AppColorsLight.secondary,
        error: AppColorsLight.error,
        surface: AppColorsLight.background,
      ),

      // Add custom colors extension for light theme
      extensions: [CustomColors.light],

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColorsLight.background,
        foregroundColor: AppColorsLight.primary,
        elevation: 0,
      ),

      // Text
      textTheme: TextTheme(bodyMedium: TextStyle(color: AppColors.primary)),

      // Dividers
      dividerTheme: DividerThemeData(color: AppColorsLight.borders, thickness: 1),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: AppColorsLight.accent, foregroundColor: Colors.white),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderSide: BorderSide(color: AppColorsLight.borders)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColorsLight.borders)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColorsLight.accent)),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColorsLight.background,
        elevation: 4,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColorsLight.borders),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
