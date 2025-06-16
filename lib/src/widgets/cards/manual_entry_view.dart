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

  bool get _isCardNumberRequired => widget.cardType?.toLowerCase() != 'sim';

  String? _validateCardNumber(String? value) {
    final loc = AppLocalizations.of(context)!;
    final val = value?.trim() ?? '';
    if (!_isCardNumberRequired && val.isEmpty) return null;
    if (_isCardNumberRequired && val.isEmpty) return loc.required_field;
    if (val.isNotEmpty) {
      final err = _formatValidator.validateField(
        'card_number',
        val,
        loc,
        cardType: widget.cardType,
        isRequired: _isCardNumberRequired,
      );
      if (err != null) return err;
      if (widget.formats.isNotEmpty && !_formatValidator.isValidFormat(val, widget.formats)) {
        return loc.invalid_card_format;
      }
    }
    return null;
  }

  void _handleSave() {
    final loc = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (widget.formManager != null && !widget.formManager!.validateAll()) {
      setState(() {});
      AppSnackBar.showError(loc.verify_entered_data);
      return;
    }
    final num = widget.cardNumberController.text.trim();
    final data = <String, dynamic>{
      'cardNumber': num.isEmpty && !_isCardNumberRequired ? null : num,
    };
    if (widget.formManager != null) data.addAll(widget.formManager!.collectData());
    widget.onSave(data);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
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

              // Card number field
              TextFormField(
                controller: widget.cardNumberController,
                decoration: InputDecoration(
                  labelText: _isCardNumberRequired
                      ? loc.card_number
                      : '${loc.card_number} (${loc.optional})',
                  hintText: loc.card_number_hint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(AntIcons.creditCardOutlined),
                ),
                inputFormatters: [],
                validator: _validateCardNumber,
              ),

              const SizedBox(height: 16),

              // Required extra fields
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
                      Text(loc.optional_fields, style: theme.textTheme.bodyMedium),
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
                  label: Text(loc.add_card),
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
