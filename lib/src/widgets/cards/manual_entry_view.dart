import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/src/themes/app_themes.dart';

class ManualEntryView extends StatelessWidget {
  final TextEditingController controller;
  final String? errorMessage;
  final Function(String) onChanged;
  final VoidCallback onSave;
  final bool isValid;
  final String assetImagePath;
  final List<String> formats;

  const ManualEntryView({
    super.key,
    required this.controller,
    this.errorMessage,
    required this.onChanged,
    required this.onSave,
    required this.isValid,
    required this.assetImagePath,
    required this.formats,
  });

  int? _extractExpectedDigits() {
    if (formats.isEmpty) return null;
    final pattern = formats.first;
    final match = RegExp(r'\\d\{(\d+)\}').firstMatch(pattern);
    return match != null ? int.tryParse(match.group(1)!) : null;
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final expected = _extractExpectedDigits();
    final formatInfo = expected != null
        ? '$expected ${local.digits}'
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  assetImagePath,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 40),

            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: local.card_number,
                errorText: errorMessage,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  local.format_hint,
                  style: theme.textTheme.bodySmall,
                ),
                if (expected != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '($expected ${local.digits})',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),

            const SizedBox(height: 46),

            Center(
              child: ElevatedButton.icon(
                icon: const Icon(AntIcons.formOutlined),
                label: Text(local.add_card),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.extension<CustomColors>()!.accent,
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                onPressed: () {
                  onChanged(controller.text);
                  if (isValid) onSave();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}