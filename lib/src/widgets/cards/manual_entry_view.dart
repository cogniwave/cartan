import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cartan/src/forms/card_form_manager.dart';
import 'package:flutter/material.dart';
import 'package:cartan/l10n/app_localizations.dart';
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
      formats: widget.formats,
    );
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    final formManager = widget.formManager;
    if (formManager == null) return;

    final data = formManager.collectData();

    final cardNumber = data['card_number']?.toString().trim() ?? '';

    final cardType = widget.cardType ?? 'loyalty';

    if (!_formatValidator.isCardNumberRequired(cardType) && cardNumber.isEmpty) {
      data.remove('card_number');
    } else if (cardNumber.isNotEmpty) {
      data['card_number'] = cardNumber;

      data['memberId'] = cardNumber;
    }

    if (!formManager.validateAll()) {
      setState(() {});
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

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CardPreviewWidget(assetImagePath: widget.assetImagePath, formManager: widget.formManager),
                ),
                const SizedBox(height: 32),

                // Required fields
                ...requiredFields.map(
                  (field) =>
                      Padding(padding: const EdgeInsets.only(bottom: 16), child: _fieldBuilder.buildField(field)),
                ),

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

                  if (_showOptionalFields)
                    ...optionalFields.map(
                      (field) =>
                          Padding(padding: const EdgeInsets.only(bottom: 16), child: _fieldBuilder.buildField(field)),
                    ),
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
      ),
    );
  }
}
