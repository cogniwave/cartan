import 'package:flutter/material.dart';
import 'package:cartan/l10n/app_localizations.dart';

class ScaffoldMessengerService {
  static final ScaffoldMessengerService _instance = ScaffoldMessengerService._internal();

  factory ScaffoldMessengerService() {
    return _instance;
  }

  ScaffoldMessengerService._internal();

  late final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  ThemeData? _currentTheme;
  AppLocalizations? _currentLocalizations;

  void initialize({required ThemeData theme, required AppLocalizations localizations}) {
    _currentTheme = theme;
    _currentLocalizations = localizations;
  }

  ThemeData get theme {
    if (_currentTheme == null) {
      throw Exception('Theme not initialized in ScaffoldMessengerService. Call initialize() first.');
    }
    return _currentTheme!;
  }

  AppLocalizations get localizations {
    if (_currentLocalizations == null) {
      throw Exception('Localizations not initialized in ScaffoldMessengerService. Call initialize() first.');
    }
    return _currentLocalizations!;
  }

  void updateTheme(ThemeData theme) {
    _currentTheme = theme;
  }

  void updateLocalizations(AppLocalizations localizations) {
    _currentLocalizations = localizations;
  }

  void showMessage({
    required String message,
    required Color color,
    required IconData icon,
    required String actionLabel,
    Duration duration = const Duration(seconds: 2),
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: TextStyle(color: color))),
        ],
      ),
      backgroundColor: color.withValues(alpha: 0.4),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(scaffoldMessengerKey.currentContext!).size.height * 0.8,
      ),
      duration: duration,
      action: SnackBarAction(
        label: actionLabel,
        textColor: color,
        onPressed: () {
          scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
        },
      ),
    );

    scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}
