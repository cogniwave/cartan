import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  LocaleProvider() {
    _loadLocaleFromPrefs();
  }

  // Load saved language
  Future<void> _loadLocaleFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');

    if (languageCode != null) {
      _locale = Locale(languageCode, '');
      notifyListeners();
    }
  }

  // Save language chosen
  Future<void> setLocale(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);

    _locale = Locale(languageCode, '');
    notifyListeners();
  }

  // Remove language preferences (uses system default)
  Future<void> clearLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('languageCode');

    _locale = null;
    notifyListeners();
  }

  // Check current language
  String getCurrentLanguage() {
    return _locale?.languageCode ?? 'system';
  }
}