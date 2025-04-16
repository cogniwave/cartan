import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/src/widgets/home_page/add_card_button.dart';

class EmptyCardsView extends StatelessWidget {
  final VoidCallback onAddPressed;

  const EmptyCardsView({
    super.key,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: <Widget>[
        Divider(
          color: theme.dividerTheme.color,
          thickness: theme.dividerTheme.thickness,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100.0, left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                localizations.empty_cards,
                style: TextStyle(
                  fontSize: 24,
                  color: theme.colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              AddCardButton(onPressed: onAddPressed),
            ],
          ),
        ),
      ],
    );
  }
}