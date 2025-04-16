import 'package:flutter/material.dart';
import 'package:cartan/utils/locale_provider.dart';

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