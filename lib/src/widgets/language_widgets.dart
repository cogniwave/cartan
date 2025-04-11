  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'package:cartan/utils/locale_provider.dart';

  class LanguageSubtitle extends StatelessWidget {
    const LanguageSubtitle({super.key});

    @override
    Widget build(BuildContext context) {
      final localeProvider = Provider.of<LocaleProvider>(context);
      final currentLanguage = localeProvider.getCurrentLanguage();

      if (currentLanguage == 'pt' || localeProvider.locale?.languageCode == 'pt') {
        return const Text('Português');
      } else if (currentLanguage == 'en' || localeProvider.locale?.languageCode == 'en') {
        return const Text('English');
      } else {
        // Fallback
        return const Text('Português');
      }
    }
  }

  class LanguageOption extends StatelessWidget {
    final String title;
    final String value;
    final String currentLanguage;
    final LocaleProvider localeProvider;

    const LanguageOption({
      super.key,
      required this.title,
      required this.value,
      required this.currentLanguage,
      required this.localeProvider,
    });

    @override
    Widget build(BuildContext context) {
      return RadioListTile<String>(
        title: Text(title),
        value: value,
        groupValue: currentLanguage,
        onChanged: (selectedValue) {
          localeProvider.setLocale(selectedValue!);
        },
      );
    }
  }