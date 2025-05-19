import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cartan/src/themes/app_themes.dart';

class ThemeProvider extends ChangeNotifier {
  // Current theme state
  bool _isDarkMode = false;
  bool _hasUserPreference = false;

  // Getter for current theme state
  bool get isDarkMode => _isDarkMode;

  // Constructor - loads saved theme when the provider is initialized
  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  // Loads theme from preferences or detects system theme
  _loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if user has a saved preference
    _hasUserPreference = prefs.containsKey('isDarkMode');

    if (_hasUserPreference) {
      // User has chosen a preference, use it
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    } else {
      // No user preference, detect system theme
      _isDarkMode = _isSystemDarkMode();
    }

    notifyListeners();
  }

  // Detects system theme
  bool _isSystemDarkMode() {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  // Saves theme to preferences
  _saveThemeToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }

  // Method to toggle between themes
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _hasUserPreference = true;
    _saveThemeToPrefs();
    notifyListeners();
  }

  // Getter for the current theme, using app_theme definitions
  ThemeData get themeData => _isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;
}