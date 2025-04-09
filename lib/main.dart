import 'package:flutter/material.dart';
import 'src/home_page.dart';
import 'utils/flavor_config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'utils/theme_provider.dart';
import 'utils/locale_provider.dart';
import 'utils/font_size_provider.dart';
import 'src/widgets/font_size_widgets.dart';
import 'dart:async';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  // package_info_plus
  final packageInfo = await PackageInfo.fromPlatform();
  final appVersion = packageInfo.version;

  final environment = FlavorConfig.instance.flavor.toString().split('.').last;

  await bugsnag.start(
    apiKey: dotenv.env['BUGSNAG_API_KEY'] ?? '',
    releaseStage: environment,
    enabledReleaseStages: {'dev', 'staging', 'prod'},
    appVersion: appVersion,
    metadata: {
      'app': {
        'environment': environment,
        'apiBaseUrl': FlavorConfig.instance.values.apiBaseUrl,
        'appName': FlavorConfig.instance.values.appName,
      },
    },
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    bugsnag.notify(details.exception, details.stack);
    FlutterError.presentError(details);
  };

  runZonedGuarded(
    () => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => FontSizeProvider()),
        ],
        child: const Cartan(),
      ),
    ),
    (Object error, StackTrace stack) => bugsnag.notify(error, stack),
  );
}

class Cartan extends StatelessWidget {
  const Cartan({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => FontSizeProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, _) {
          return MaterialApp(
            title: FlavorConfig.instance.values.appName,
            theme: themeProvider.themeData,
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('pt', ''),
              Locale('en', ''),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            navigatorObservers: [BugsnagNavigatorObserver()],
            builder: (context, child) {
              return FontSizeScaler(child: child!);
            },
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
