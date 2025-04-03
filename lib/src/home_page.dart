import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cartan/utils/messages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          localizations.cards,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.primary),
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
                    value: 'help',
                    child: Text(localizations.help),
                  ),

                ],
                elevation: 8,
              ).then((value) {
                if (value != null) {
                  // Menu options
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Divider(
            color: Theme.of(context).dividerTheme.color,
            thickness: Theme.of(context).dividerTheme.thickness,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  localizations.emptyCards,
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                ElevatedButton.icon(
                  icon: const Icon(AntIcons.plusCircleOutlined),
                  label: Text(localizations.add),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  onPressed: () {
                    // Add button action
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  label: Text('success'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiaryFixed,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Messages.showSuccess(context, localizations.success);
                  },
                ),
                ElevatedButton.icon(
                  label: Text('error'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Messages.showError(context, localizations.error);
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