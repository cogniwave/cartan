import 'package:flutter/material.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Messages {
  // Success message
  static void showSuccess(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
              AntIcons.checkOutlined,
              color: Theme.of(context).colorScheme.tertiaryFixed
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Theme.of(context).colorScheme.tertiaryFixed),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.tertiaryFixed.withValues(alpha: 0.4,),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'OK',
        textColor: Theme.of(context).colorScheme.tertiaryFixed,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Error message
  static void showError(BuildContext context, String message) {
    final localizations = AppLocalizations.of(context)!;

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            AntIcons.closeOutlined,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.4,),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
      action: SnackBarAction(
        label: localizations.close,
        textColor: Theme.of(context).colorScheme.error,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}