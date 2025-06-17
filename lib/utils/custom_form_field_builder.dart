import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cartan/src/forms/card_form_manager.dart';
import 'package:cartan/src/models/card_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/utils/card_format_validator.dart';

class CustomFormFieldBuilder {
  final CardFormManager? formManager;
  final AppLocalizations localizations;
  final BuildContext context;
  final CardFormatValidator _validator = CardFormatValidator();
  final String? cardType;
  final List<String> formats;
  final CardFormatValidator _formatValidator;

  CustomFormFieldBuilder({
    required this.localizations,
    required this.context,
    this.formManager,
    this.cardType,
    required this.formats,
  }) : _formatValidator = CardFormatValidator();


  Widget buildField(FormFieldConfig field) {
    final controller = formManager?.getController(field.key);
    if (controller == null) return const SizedBox.shrink();

    final decoration = _buildInputDecoration(field);
    final formatters = _buildInputFormatters(field);
    final validator = _buildValidator(field);

    return _buildTextFormField(
      field,
      controller,
      decoration,
      formatters,
      validator,
    );
  }

  InputDecoration _buildInputDecoration(FormFieldConfig field) {
    // Check if field should be marked as optional for SIM cards
    final isOptional = _isFieldOptional(field.key);
    final baseLabel = _getLocalizedText(field.labelKey);

    final labelText = isOptional
        ? '$baseLabel (${localizations.optional})'
        : baseLabel;

    return InputDecoration(
      labelText: labelText,
      hintText:
      field.hintKey != null ? _getLocalizedText(field.hintKey!) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  // Check if field should be optional
  bool _isFieldOptional(String fieldKey) {
    if (cardType?.toLowerCase() == null) return false;

    final ct = cardType!.toLowerCase();
    final normalizedKey = fieldKey.toLowerCase();

    if (ct == 'sim' || ct == 'business' || ct == 'informative' || ct == 'other') {
      return normalizedKey == 'phone_number' ||
          normalizedKey == 'phone' ||
          normalizedKey == 'card_number' ||
          normalizedKey == 'cardnumber';
    }

    return false;
  }

  // Check if field is required based on card type and field key
  bool _isFieldRequired(FormFieldConfig field) {
    final ct = cardType?.toLowerCase();
    final normalizedKey = field.key.toLowerCase();

    if (ct == 'sim' || ct == 'business' || ct == 'informative' || ct == 'other') {
      if (normalizedKey == 'phone_number' ||
          normalizedKey == 'phone' ||
          normalizedKey == 'card_number' ||
          normalizedKey == 'cardnumber') {
        return false;
      }
    }

    return field.isRequired;
  }

  List<TextInputFormatter> _buildInputFormatters(FormFieldConfig field) {
    List<TextInputFormatter> formatters = [];

    switch (field.inputType) {
      case InputType.numeric:
        formatters.add(FilteringTextInputFormatter.digitsOnly);
        break;
      case InputType.phone:
        formatters.add(
          FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s()]')),
        );
        break;
      case InputType.email:
        formatters.add(
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')),
        );
        break;
      case InputType.text:
      case InputType.multiline:
      case InputType.date:
      case InputType.dropdown:
        break;
    }

    if (field.maxLength != null && field.maxLength! > 0) {
      formatters.add(LengthLimitingTextInputFormatter(field.maxLength!));
    }

    return formatters;
  }

  String? Function(String?)? _buildValidator(FormFieldConfig field) {
    final isRequired = _isFieldRequired(field);

    if (!isRequired && field.inputType != InputType.email) {
      return (value) {
        if (value?.trim().isEmpty == true) return null;

        // Validação básica do campo
        final basicError = _validator.validateField(
          field.key,
          value!,
          localizations,
          cardType: cardType,
          inputType: field.inputType,
          isRequired: false,
        );

        if (basicError != null) return basicError;

        // Validação de formato específica para card_number
        if (field.key == 'card_number') {
          final formats = _getFormatsFromContext();
          if (formats.isNotEmpty && !_formatValidator.isValidFormat(value, formats)) {
            return localizations.invalid_card_format;
          }
        }

        return null;
      };
    }

    return (value) {
      if (value?.trim().isEmpty == true) {
        return isRequired ? localizations.required_field : null;
      }

      // Validação básica do campo
      final basicError = _validator.validateField(
        field.key,
        value!,
        localizations,
        cardType: cardType,
        inputType: field.inputType,
        isRequired: isRequired,
      );

      if (basicError != null) return basicError;

      // Validação de formato específica para card_number
      if (field.key == 'card_number') {
        final formats = _getFormatsFromContext();
        if (formats.isNotEmpty && !_formatValidator.isValidFormat(value, formats)) {
          return localizations.invalid_card_format;
        }
      }

      return null;
    };
  }

  List<String> _getFormatsFromContext() {
    return formats;
  }

  Widget _buildTextFormField(
      FormFieldConfig field,
      TextEditingController controller,
      InputDecoration decoration,
      List<TextInputFormatter> formatters,
      String? Function(String?)? validator,
      ) {
    if (field.inputType == InputType.dropdown && field.options != null) {
      return _buildDropdownField(field, controller, decoration, validator);
    }

    if (field.inputType == InputType.date) {
      return _buildDateField(field, controller, decoration, validator);
    }

    final iconData = _getFieldIconData(field.key);

    return FormField<String>(
      validator: validator,
      initialValue: controller.text,
      builder: (FormFieldState<String> fieldState) {
        return TextFormField(
          controller: controller,
          keyboardType: _getKeyboardType(field.inputType),
          maxLines: field.inputType == InputType.multiline ? 3 : 1,
          inputFormatters: formatters,
          decoration: decoration.copyWith(
            prefixIcon: iconData != null
                ? Icon(iconData, color: fieldState.hasError ? Theme.of(context).colorScheme.error : null)
                : null,
            errorText: fieldState.errorText,
          ),
          onChanged: (value) {
            fieldState.didChange(value);
            // controller.text = value;
          },
          onTap: () {
            fieldState.reset();
          },
        );
      },
    );
  }

  Widget _buildDropdownField(
      FormFieldConfig field,
      TextEditingController controller,
      InputDecoration decoration,
      String? Function(String?)? validator,
      ) {
    return DropdownButtonFormField<String>(
      value: controller.text.isEmpty ? null : controller.text,
      decoration: decoration,
      items: field.options!.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        controller.text = newValue ?? '';
      },
      validator: validator,
    );
  }

  Widget _buildDateField(
      FormFieldConfig field,
      TextEditingController controller,
      InputDecoration decoration,
      String? Function(String?)? validator,
      ) {
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
  }

  TextInputType _getKeyboardType(InputType inputType) {
    switch (inputType) {
      case InputType.numeric:
        return TextInputType.number;
      case InputType.phone:
        return TextInputType.phone;
      case InputType.email:
        return TextInputType.emailAddress;
      case InputType.multiline:
        return TextInputType.multiline;
      case InputType.text:
      case InputType.date:
      case InputType.dropdown:
        return TextInputType.text;
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) {
      controller.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  String _getLocalizedText(String key) {
    final localizationMap = {
      'phone_number': localizations.phone_number,
      'phone_number_hint': localizations.phone_number_hint,
      'pin_label': localizations.pin_label,
      'pin_hint': localizations.pin_hint,
      'puk_label': localizations.puk_label,
      'puk_hint': localizations.puk_hint,
      'card_number': localizations.card_number,
      'card_number_hint': localizations.card_number_hint,
    };

    return localizationMap[key] ?? key;
  }

  static const Map<String, IconData> _iconMap = {
    'email': AntIcons.mailOutlined,
    'phone': AntIcons.phoneOutlined,
    'phone_number': AntIcons.phoneOutlined,
    'name': AntIcons.manOutlined,
    'membername': AntIcons.manOutlined,
    'member_name': AntIcons.manOutlined,
    'company': AntIcons.buildOutlined,
    'position': AntIcons.userOutlined,
    'address': AntIcons.contactsOutlined,
    'points': AntIcons.starOutlined,
    'tier': AntIcons.crownOutlined,
    'pin': AntIcons.lockOutlined,
    'puk': AntIcons.lockOutlined,
    'cardnumber': AntIcons.creditCardOutlined,
    'card_number': AntIcons.creditCardOutlined,
    'cardNumber': AntIcons.creditCardOutlined,
    'expirydate': AntIcons.calendarOutlined,
    'expiry_date': AntIcons.calendarOutlined,
    'description': AntIcons.fileTextOutlined,
    'instructions': AntIcons.bookOutlined,
    'membertype': AntIcons.tagOutlined,
    'member_type': AntIcons.tagOutlined,
  };

  IconData? _getFieldIconData(String fieldKey) {
    return _iconMap[fieldKey.toLowerCase()];
  }
}