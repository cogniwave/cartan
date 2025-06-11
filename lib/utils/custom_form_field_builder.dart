import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cartan/src/forms/card_form_manager.dart';
import 'package:cartan/src/models/card_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'card_format_validator.dart';

class CustomFormFieldBuilder {
  final CardFormManager? formManager;
  final AppLocalizations localizations;
  final BuildContext context;
  final CardFormatValidator _validator = CardFormatValidator();

  CustomFormFieldBuilder({
    required this.localizations,
    required this.context,
    this.formManager,
  });

  // Main field construction method
  Widget buildField(FormFieldConfig field) {
    final controller = formManager?.getController(field.key);
    if (controller == null) return const SizedBox.shrink();

    final decoration = _buildInputDecoration(field);
    final formatters = _buildInputFormatters(field);
    final validator = _buildValidator(field);

    return _buildTextFormField(field, controller, decoration, formatters, validator);
  }

  // Input decoration builder
  InputDecoration _buildInputDecoration(FormFieldConfig field) {
    return InputDecoration(
      labelText: _getLocalizedText(field.labelKey),
      hintText: field.hintKey != null ? _getLocalizedText(field.hintKey!) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      errorText: formManager?.getFieldError(field.key),
      prefixIcon: _getFieldIcon(field.key),
    );
  }

  // Input formatters builder
  List<TextInputFormatter> _buildInputFormatters(FormFieldConfig field) {
    List<TextInputFormatter> formatters = [];

    switch (field.inputType) {
      case InputType.numeric:
        formatters.add(FilteringTextInputFormatter.digitsOnly);
        break;
      case InputType.phone:
        formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s()]')));
        break;
      default:
        break;
    }

    if (field.maxLength != null && field.maxLength! > 0) {
      formatters.add(LengthLimitingTextInputFormatter(field.maxLength!));
    }

    return formatters;
  }

  // Validator builder
  String? Function(String?)? _buildValidator(FormFieldConfig field) {
    if (!field.isRequired) return null;

    return (value) {
      if (value?.trim().isEmpty == true) {
        return localizations.required_field;
      }

      // Uses CardFormatValidator for specific validations
      return _validator.validateField(field.key, field.inputType, value!, localizations);
    };
  }

  // TextFormField widget builder
  Widget _buildTextFormField(
      FormFieldConfig field,
      TextEditingController controller,
      InputDecoration decoration,
      List<TextInputFormatter> formatters,
      String? Function(String?)? validator,
      ) {
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
      default:
        return TextFormField(
          controller: controller,
          decoration: decoration,
          inputFormatters: formatters,
          validator: validator,
        );
    }
  }

  // Date picker helper method
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

  // Localization methods
  String _getLocalizedText(String key) {
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

  // Icon methods
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
}