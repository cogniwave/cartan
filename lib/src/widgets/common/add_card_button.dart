import 'package:flutter/material.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/src/themes/app_themes.dart';

class AddCardButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddCardButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColor = Theme.of(context).extension<CustomColors>()!;
    final localizations = AppLocalizations.of(context)!;

    return ElevatedButton.icon(
      icon: const Icon(AntIcons.plusCircleOutlined),
      label: Text(localizations.add),
      style: ElevatedButton.styleFrom(
        backgroundColor: customColor.accentAlt,
        foregroundColor: theme.colorScheme.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onPressed: onPressed,
    );
  }
}