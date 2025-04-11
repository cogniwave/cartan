import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/utils/font_size_provider.dart';
import 'package:cartan/src/widgets/font_size_widgets.dart';

class FontSizeScreen extends StatelessWidget {
  const FontSizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    final currentFontSize = fontSizeProvider.fontSizeScale;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.font_size),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          FontSizeOption(
            title: localizations.large_font,
            value: 1.75,
            currentFontSize: currentFontSize,
            fontSizeProvider: fontSizeProvider,
          ),
          FontSizeOption(
            title: localizations.normal_font,
            value: 1.0,
            currentFontSize: currentFontSize,
            fontSizeProvider: fontSizeProvider,
          ),
          FontSizeOption(
            title: localizations.small_font,
            value: 0.5,
            currentFontSize: currentFontSize,
            fontSizeProvider: fontSizeProvider,
          ),
        ],
      ),
    );
  }
}