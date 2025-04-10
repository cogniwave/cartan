import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../utils/locale_provider.dart';

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
          RadioListTile<String>(
            title: Text('Português'),
            value: 'pt',
            groupValue: currentLanguage,
            onChanged: (value) {
              if (value != null) {
                localeProvider.setLocale(value);
                Navigator.pop(context);
              }
            },
          ),
          RadioListTile<String>(
            title: Text('English'),
            value: 'en',
            groupValue: currentLanguage,
            onChanged: (value) {
              if (value != null) {
                localeProvider.setLocale(value);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}