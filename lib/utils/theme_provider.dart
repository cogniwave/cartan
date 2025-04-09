import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../src/themes/app_themes.dart';

class ThemeProvider extends ChangeNotifier {
  // Current theme state
  bool _isDarkMode = false;

  // Getter for current theme state
  bool get isDarkMode => _isDarkMode;

  // Constructor - loads saved theme when the provider is initialized
  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  // Loads theme from preferences
  _loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  // Saves theme to preferences
  _saveThemeToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }

  // Method to toggle between themes
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemeToPrefs();
    notifyListeners();
  }

  // Method to set a specific theme
  void setDarkMode(bool isDark) {
    _isDarkMode = isDark;
    _saveThemeToPrefs();
    notifyListeners();
  }

  // Getter for the current theme, using app_theme definitions
  ThemeData get themeData => _isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;
}