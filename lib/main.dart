import 'package:flutter/material.dart';
import 'package:cartan/src/home_page.dart';
import 'package:cartan/utils/flavor_config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/src/themes/app_themes.dart';
import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  // final bugsnagApiKey = 'd591b3ade83580c510f9fc556bfe7115';

  final bugsnagApiKey = dotenv.env['TESTE_API_KEY'] ?? 'BUGSNAG_API_KEY';

  
  await bugsnag.start(
    apiKey: bugsnagApiKey,
    releaseStage: FlavorConfig.instance.flavor.toString().split('.').last,
    enabledReleaseStages: {'dev', 'staging', 'prod'},
    appVersion: '1.0.0',
    metadata: {
      'app': {
        'environment': FlavorConfig.instance.flavor.toString().split('.').last,
        'apiBaseUrl': FlavorConfig.instance.values.apiBaseUrl,
        'appName': FlavorConfig.instance.values.appName,
      }
    },
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    bugsnag.notify(details.exception, details.stack);
    FlutterError.presentError(details);
  };

  runZonedGuarded(() {
    runApp(const MyApp());
  }, (Object error, StackTrace stack) {
    bugsnag.notify(error, stack);
  });
  
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
        Locale('pt', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      navigatorObservers: [
        BugsnagNavigatorObserver(),
      ],
      home: const HomePage(),
    );
  }
}