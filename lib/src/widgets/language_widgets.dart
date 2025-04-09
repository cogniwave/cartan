import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSubtitle extends StatelessWidget {
  const LanguageSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLanguage = localeProvider.getCurrentLanguage();

    switch (currentLanguage) {
      case 'pt':
        return const Text('Português');
      case 'en':
        return const Text('English');
      default:
        return Text(AppLocalizations.of(context)!.system_default);
    }
  }
}
