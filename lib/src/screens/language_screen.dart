import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/utils/locale_provider.dart';
import 'package:cartan/src/widgets/language_widgets.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    final currentLanguage = localeProvider.getCurrentLanguage();

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.language),
      ),
      body: ListView(
        children: [
          LanguageOption(
            title: 'Português',
            value: 'pt',
            currentLanguage: currentLanguage,
            localeProvider: localeProvider,
          ),
          LanguageOption(
            title: 'English',
            value: 'en',
            currentLanguage: currentLanguage,
            localeProvider: localeProvider,
          ),
        ],
      ),
    );
  }
}