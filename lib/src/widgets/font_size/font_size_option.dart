import 'package:flutter/material.dart';
import 'package:cartan/utils/font_size_provider.dart';

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