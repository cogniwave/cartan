import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'themes/app_themes.dart';
import 'screens/settings_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final customColor = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          localizations.cards,
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: theme.colorScheme.primary),
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  MediaQuery.of(context).size.width,
                  kToolbarHeight,
                  0,
                  0,
                ),
                items: [
                  PopupMenuItem(
                    value: 'settings',
                    child: Text(localizations.settings),
                  ),
                  PopupMenuItem(
                    value: 'help',
                    child: Text(localizations.help),
                  ),
                ],
                elevation: 8,
              ).then((value) {
                if (value != null) {
                  if (value == 'settings') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  } else if (value == 'help') {
                    // Help option menu
                  }
                }
              });
            },
          ),
        ]
      ),
      body: Column(
        children: <Widget>[
          Divider(
            color: theme.dividerTheme.color,
            thickness: theme.dividerTheme.thickness,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 100.0,
              left: 16.0,
              right: 16.0,
            ),
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
                ElevatedButton.icon(
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
                  onPressed: () {
                    // Button action
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}