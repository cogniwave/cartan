import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cartan/src/forms/card_form_manager.dart';
import 'package:cartan/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/src/themes/app_themes.dart';
import 'package:cartan/utils/custom_form_field_builder.dart';
import 'card_preview_widget.dart';
import 'package:cartan/utils/card_format_validator.dart';

class ManualEntryView extends StatefulWidget {
  final TextEditingController cardNumberController;
  final Function(Map<String, dynamic>) onSave;
  final String assetImagePath;
  final List<String> formats;
  final CardFormManager? formManager;

  const ManualEntryView({
    super.key,
    required this.cardNumberController,
    required this.onSave,
    required this.assetImagePath,
    required this.formats,
    this.formManager,
  });

  @override
  State<ManualEntryView> createState() => _ManualEntryViewState();
}

class _ManualEntryViewState extends State<ManualEntryView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final CardFormatValidator _formatValidator;
  late CustomFormFieldBuilder _fieldBuilder;

  @override
  void initState() {
    super.initState();
    _formatValidator = CardFormatValidator();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fieldBuilder = CustomFormFieldBuilder(
      localizations: AppLocalizations.of(context)!,
      context: context,
      formManager: widget.formManager,
    );
  }

  // Extract expected digits from format pattern
  int _extractExpectedDigits() {
    if (widget.formats.isEmpty) return 0;
    final pattern = widget.formats.first;
    final match = RegExp(r'\{(\d+),').firstMatch(pattern);
    return (match != null) ? int.parse(match.group(1)!) : 0;
  }

  // Handle save action
  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    if (widget.formManager != null && !widget.formManager!.validateAll()) {
      setState(() {});
      AppSnackBar.showError(AppLocalizations.of(context)!.verify_entered_data);
      return;
    }

    Map<String, dynamic> allData = {
      'cardNumber': widget.cardNumberController.text.trim(),
    };

    if (widget.formManager != null) {
      allData.addAll(widget.formManager!.collectData());
    }

    widget.onSave(allData);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final hasSpecificFormat = widget.formats.isNotEmpty;
    final expectedDigits = hasSpecificFormat ? _extractExpectedDigits() : null;
    final additionalFields = widget.formManager?.fields ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Preview
              Center(
                child: CardPreviewWidget(
                  assetImagePath: widget.assetImagePath,
                  formManager: widget.formManager,
                ),
              ),
              const SizedBox(height: 32),

              // Card Number Field
              TextFormField(
                controller: widget.cardNumberController,
                decoration: InputDecoration(
                  labelText: localizations.card_number,
                  hintText: localizations.card_number_hint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(AntIcons.creditCardOutlined),
                ),
                keyboardType: TextInputType.text,
                inputFormatters: (hasSpecificFormat && expectedDigits != null && expectedDigits > 0)
                    ? [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(expectedDigits),
                ]
                    : [],
                validator: (value) {
                  if (value?.trim().isEmpty == true) {
                    return localizations.required_field;
                  }
                  if (hasSpecificFormat && !_formatValidator.isValidFormat(value!.trim(), widget.formats)) {
                    return localizations.invalid_card_format;
                  }
                  return null;
                },
              ),

              // Additional Fields (built by FormFieldBuilder)
              if (additionalFields.isNotEmpty) ...[
                const SizedBox(height: 16),
                ...additionalFields.map(
                      (field) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _fieldBuilder.buildField(field),
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Save Button
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(AntIcons.formOutlined),
                  label: Text(localizations.add_card),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.extension<CustomColors>()!.accent,
                    foregroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    elevation: 2,
                  ),
                  onPressed: _handleSave,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}