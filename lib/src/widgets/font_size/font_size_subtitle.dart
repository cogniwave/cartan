import 'package:flutter/material.dart';
import 'package:cartan/utils/font_size_provider.dart';
import 'package:provider/provider.dart';
import 'package:cartan/l10n/app_localizations.dart';

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
