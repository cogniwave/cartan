import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/locale_provider.dart';

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