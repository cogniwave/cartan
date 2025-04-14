import 'package:flutter/material.dart';
import 'package:cartan/utils/font_size_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FontSizeScaler extends StatelessWidget {
  final Widget child;

  const FontSizeScaler({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final fontSizeScale = fontSizeProvider.fontSizeScale;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(fontSizeScale),
      ),
      child: child,
    );
  }
}

class FontSizeSubtitle extends StatelessWidget {
  const FontSizeSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final scale = fontSizeProvider.fontSizeScale;
    final localizations = AppLocalizations.of(context)!;

    if (scale == 1.75) {
      return Text(localizations.large_font);
    } else if (scale == 0.5) {
      return Text(localizations.small_font);
    } else {
      return Text(localizations.normal_font);
    }
  }
}

class FontSizeOption extends StatelessWidget {
  final String title;
  final double value;
  final double currentFontSize;
  final FontSizeProvider fontSizeProvider;

  const FontSizeOption({
    super.key,
    required this.title,
    required this.value,
    required this.currentFontSize,
    required this.fontSizeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<double>(
      title: Text(title),
      value: value,
      groupValue: currentFontSize,
      onChanged: (newValue) {
        fontSizeProvider.setFontSize(newValue!);
      },
    );
  }
}