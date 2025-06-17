import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cartan/src/forms/card_form_manager.dart';
import 'package:cartan/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
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
  final String? cardType;

  const ManualEntryView({
    super.key,
    required this.cardNumberController,
    required this.onSave,
    required this.assetImagePath,
    required this.formats,
    this.formManager,
    this.cardType,
  });

  @override
  State<ManualEntryView> createState() => _ManualEntryViewState();
}

class _ManualEntryViewState extends State<ManualEntryView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final CardFormatValidator _formatValidator;
  late CustomFormFieldBuilder _fieldBuilder;
  bool _showOptionalFields = false;

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
      cardType: widget.cardType,
    );
  }

  void _handleSave() {
    final localizations = AppLocalizations.of(context)!;
    final validator = _formatValidator;
    final formats = widget.formats;

    if (!_formKey.currentState!.validate()) return;

    final formManager = widget.formManager;

    if (formManager == null) return;

    final cardType = widget.cardType ?? 'loyalty';

    final data = formManager.collectData();
    final cardNumber = data['cardNumber']?.toString().trim() ?? '';

    if (formManager.controllers.containsKey('cardNumber')) {
      final isRequired = validator.isCardNumberRequired(cardType);

      final error = validator.validateField(
        'cardNumber',
        cardNumber,
        localizations,
        cardType: cardType,
        isRequired: isRequired,
      );

      if (error != null) {
        AppSnackBar.showError(error);
        return;
      }

      if (!isRequired && cardNumber.isEmpty) {
        data.remove('cardNumber');
      } else {
        data['cardNumber'] = cardNumber;
      }
    }

    if (!formManager.validateAll()) {
      setState(() {});
      AppSnackBar.showError(localizations.verify_entered_data);
      return;
    }

    if (formats.isNotEmpty && !_formatValidator.isValidFormat(cardNumber, formats)) {
      AppSnackBar.showError(localizations.invalid_card_format);
      return;
    }

    widget.onSave(data);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final allFields = widget.formManager?.fields ?? [];
    // Separate required/optional based on field.isRequired
    final requiredFields = allFields.where((f) => f.isRequired).toList();
    final optionalFields = allFields.where((f) => !f.isRequired).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CardPreviewWidget(
                  assetImagePath: widget.assetImagePath,
                  formManager: widget.formManager,
                ),
              ),
              const SizedBox(height: 32),

              // Required fields
              ...requiredFields.map((field) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _fieldBuilder.buildField(field),
              )),

              // Optional toggle
              if (optionalFields.isNotEmpty) ...[
                GestureDetector(
                  onTap: () => setState(() => _showOptionalFields = !_showOptionalFields),
                  child: Row(
                    children: [
                      Text(localizations.optional_fields, style: theme.textTheme.bodyMedium),
                      const SizedBox(width: 8),
                      Icon(_showOptionalFields ? Icons.expand_less : Icons.expand_more),
                    ],
                  ),
                ),
                if (_showOptionalFields) ...optionalFields.map((field) => Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: _fieldBuilder.buildField(field),
                )),
              ],

              const SizedBox(height: 32),

              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(AntIcons.formOutlined),
                  label: Text(localizations.add_card),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.extension<CustomColors>()!.accent,
                    foregroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
