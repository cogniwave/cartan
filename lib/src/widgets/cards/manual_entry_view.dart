import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cartan/src/forms/card_form_manager.dart';
import 'package:cartan/src/models/card_configuration.dart';
import 'package:cartan/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/src/themes/app_themes.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  @override
  void dispose() {
    super.dispose();
  }

  int _extractExpectedDigits() {
    if (widget.formats.isEmpty) return 0;
    final pattern = widget.formats.first;
    final match = RegExp(r'\{(\d+),').firstMatch(pattern);
    return (match != null) ? int.parse(match.group(1)!) : 0;
  }

  String _getLocalizedText(AppLocalizations localizations, String key) {
    final localizationMap = {
      // SIM Card fields
      'phone_number': localizations.phone_number,
      'phone_number_hint': localizations.phone_number_hint,
      'pin_label': localizations.pin_label,
      'pin_hint': localizations.pin_hint,
      'puk_label': localizations.puk_label,
      'puk_hint': localizations.puk_hint,

      // Common fields
      'card_number': localizations.card_number,
      'card_number_hint': localizations.card_number_hint,
    };
    return localizationMap[key] ?? key;
  }

  Widget _buildFieldWidget(FormFieldConfig field, AppLocalizations localizations) {
    final controller = widget.formManager?.getController(field.key);
    if (controller == null) return const SizedBox.shrink();

    InputDecoration decoration = InputDecoration(
      labelText: _getLocalizedText(localizations, field.labelKey),
      hintText: field.hintKey != null
          ? _getLocalizedText(localizations, field.hintKey!)
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      errorText: widget.formManager?.getFieldError(field.key),
      prefixIcon: _getFieldIcon(field.key),
    );

    List<TextInputFormatter> formatters = [];
    switch (field.inputType) {
      case InputType.numeric:
        formatters.add(FilteringTextInputFormatter.digitsOnly);
        if (field.maxLength != null && field.maxLength! > 0) {
          formatters.add(LengthLimitingTextInputFormatter(field.maxLength!));
        }
        break;
      case InputType.phone:
        if (field.maxLength != null && field.maxLength! > 0) {
          formatters.add(LengthLimitingTextInputFormatter(field.maxLength!));
        }
        break;
      case InputType.text:
        if (field.maxLength != null && field.maxLength! > 0) {
          formatters.add(LengthLimitingTextInputFormatter(field.maxLength!));
        }
        break;
      default:
        break;
    }

    String? Function(String?)? validator;
    if (field.isRequired) {
      validator = (value) {
        if (value?.trim().isEmpty == true) {
          return localizations.required_field;
        }
        if (field.inputType == InputType.email && value != null && value.isNotEmpty) {
          final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value)) {
            return localizations.invalid_email;
          }
        }
        return null;
      };
    }

    switch (field.inputType) {
      case InputType.numeric:
        return TextFormField(
          controller: controller,
          decoration: decoration,
          keyboardType: TextInputType.number,
          inputFormatters: formatters,
          validator: validator,
        );
      case InputType.phone:
        return TextFormField(
          controller: controller,
          decoration: decoration,
          keyboardType: TextInputType.phone,
          inputFormatters: formatters,
          validator: validator,
        );
      case InputType.email:
        return TextFormField(
          controller: controller,
          decoration: decoration,
          keyboardType: TextInputType.emailAddress,
          validator: validator,
        );
      case InputType.multiline:
        return TextFormField(
          controller: controller,
          decoration: decoration,
          maxLines: 3,
          validator: validator,
        );
      case InputType.date:
        return TextFormField(
          controller: controller,
          decoration: decoration.copyWith(
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _selectDate(controller),
            ),
          ),
          readOnly: true,
          validator: validator,
        );
      default: // InputType.text
        return TextFormField(
          controller: controller,
          decoration: decoration,
          inputFormatters: formatters,
          validator: validator,
        );
    }
  }

  Icon? _getFieldIcon(String fieldKey) {
    switch (fieldKey.toLowerCase()) {
      case 'email':
        return const Icon(AntIcons.mailOutlined);
      case 'phone':
      case 'phone_number':
        return const Icon(AntIcons.phoneOutlined);
      case 'name':
      case 'membername':
        return const Icon(AntIcons.manOutlined);
      case 'company':
        return const Icon(AntIcons.buildOutlined);
      case 'address':
        return const Icon(AntIcons.contactsOutlined);
      case 'points':
        return const Icon(AntIcons.starOutlined);
      case 'pin':
      case 'puk':
        return const Icon(AntIcons.lockOutlined);
      default:
        return null;
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)), // 10 years
    );
    if (picked != null) {
      controller.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.formManager != null) {
      if (!widget.formManager!.validateAll()) {
        setState(() {});
        AppSnackBar.showError(AppLocalizations.of(context)!.verify_entered_data);
        return;
      }
    }

    Map<String, dynamic> allData = {
      'cardNumber': widget.cardNumberController.text.trim(),
    };
    if (widget.formManager != null) {
      final additionalData = widget.formManager!.collectData();
      allData.addAll(additionalData);
    }
    widget.onSave(allData);
  }

  Widget _buildCardPreview() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 150,
              height: 100,
              child: FittedBox(
                fit: BoxFit.fill,
                child: SvgPicture.asset(widget.assetImagePath),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (widget.formManager?.cardTypeData.displayName != null)
            Text(
              widget.formManager!.cardTypeData.displayName!,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
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
              Center(child: _buildCardPreview()),
              const SizedBox(height: 32),

              TextFormField(
                controller: widget.cardNumberController,
                decoration: InputDecoration(
                  labelText: localizations.card_number,
                  hintText: _getLocalizedText(localizations, 'card_number_hint'),
                  errorText: null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(AntIcons.creditCardOutlined),
                ),
                keyboardType: TextInputType.text,
                inputFormatters: (hasSpecificFormat && expectedDigits != null && expectedDigits > 0)
                    ? <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(expectedDigits),
                ]
                    : <TextInputFormatter>[],
                validator: (value) {
                  if (value?.trim().isEmpty == true) {
                    return localizations.required_field;
                  }
                  if (hasSpecificFormat && expectedDigits != null && expectedDigits > 0) {
                    final memberId = value!.trim();
                    final regex = RegExp(widget.formats.first);
                    if (!regex.hasMatch(memberId)) {
                      return localizations.invalid_card_format;
                    }
                  }
                  return null;
                },
              ),

              if (additionalFields.isNotEmpty) ...[
                const SizedBox(height: 16),
                ...additionalFields.map(
                      (field) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildFieldWidget(field, localizations),
                  ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
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