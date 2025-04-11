import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  final List<String> supportedLanguages = ['pt', 'en'];
  final String defaultLanguage = 'pt';

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
    } else {
      final deviceLocale = PlatformDispatcher.instance.locale.languageCode;

      // Check if system language is supported
      if (supportedLanguages.contains(deviceLocale)) {
        _locale = Locale(deviceLocale, '');
      } else {
        _locale = Locale(defaultLanguage, '');
      }

      await prefs.setString('languageCode', _locale!.languageCode);
    }

    notifyListeners();
  }

  // Save language chosen by user
  Future<void> setLocale(String languageCode) async {
    if (supportedLanguages.contains(languageCode)) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', languageCode);

      _locale = Locale(languageCode, '');
      notifyListeners();
    }
  }

  // Check current language
  String getCurrentLanguage() {
    return _locale?.languageCode ?? defaultLanguage;
  }
}