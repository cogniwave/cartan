import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontSizeProvider extends ChangeNotifier {
  double _fontSizeScale = 1.0;

  double get fontSizeScale => _fontSizeScale;

  FontSizeProvider() {
    _loadFontSizeFromPrefs();
  }

  Future<void> _loadFontSizeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _fontSizeScale = prefs.getDouble('fontSizeScale') ?? 1.0;
    notifyListeners();
  }

  Future<void> setFontSize(double scale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSizeScale', scale);

    _fontSizeScale = scale;
    notifyListeners();
  }
}