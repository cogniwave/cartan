import 'package:flutter/material.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/src/themes/app_themes.dart';

class AppSnackBar {

  // Method show any message
  static void _showMessage({
    required BuildContext context,
    required String message,
    required Color color,
    required IconData icon,
    required String actionLabel,
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: color),
            ),
          ),
        ],
      ),
      backgroundColor: color.withValues(alpha: 0.4),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(16),
      duration: duration,
      action: SnackBarAction(
        label: actionLabel,
        textColor: color,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Success message
  static void showSuccess(BuildContext context, String message) {
    _showMessage(
      context: context,
      message: message,
      color: Theme.of(context).extension<CustomColors>()!.success,
      icon: AntIcons.checkOutlined,
      actionLabel: 'OK',
    );
  }

  // Error message
  static void showError(BuildContext context, String message) {
    _showMessage(
      context: context,
      message: message,
      color: Theme.of(context).colorScheme.error,
      icon: AntIcons.closeOutlined,
      actionLabel: AppLocalizations.of(context)!.close,
      duration: const Duration(seconds: 4),
    );
  }
}