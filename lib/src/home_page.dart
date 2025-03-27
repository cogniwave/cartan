import 'package:flutter/material.dart';
import 'package:cartan/utils/flavor_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:antdesign_icons/antdesign_icons.dart';


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
        title: Center(
          child: Text(localizations.title),
        ),
      ),
      body: Column(
        children: <Widget>[
          Divider(
            color: Theme.of(context).dividerTheme.color,
            thickness: Theme.of(context).dividerTheme.thickness,
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    AntIcons.smileOutlined,
                    size: 100,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    localizations.greeting,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ambiente de desenvolvimento: ${FlavorConfig.instance.name}')),
                      );
                    },
                    child: Text('Ambiente de desenvolvimento'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}