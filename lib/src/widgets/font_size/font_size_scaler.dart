import 'package:flutter/material.dart';
import 'package:cartan/utils/font_size_provider.dart';
import 'package:provider/provider.dart';

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