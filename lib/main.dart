import 'package:flutter/material.dart';
import 'package:cartan/src/home_page.dart';
import 'package:cartan/utils/flavor_config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/src/themes/app_themes.dart';

void initializeApp() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: FlavorConfig.instance.values.appName,
      theme: AppThemes.darkTheme,
      supportedLocales: const [
        Locale('pt', ''), // Português
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const HomePage(), // Não passes o título aqui
    );
  }
}
