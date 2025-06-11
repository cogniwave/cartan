import 'package:cartan/src/models/card_configuration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardFormatValidator {
  // Original card format validation
  bool isValidFormat(String code, List<String> formats) {
    if (code.isEmpty) return false;

    if (formats.isEmpty) {
      final defaultRegex = RegExp(r'^[A-Za-z0-9]+$');
      return defaultRegex.hasMatch(code);
    }

    for (final pattern in formats) {
      final regex = RegExp(pattern);
      if (regex.hasMatch(code)) {
        return true;
      }
    }
    return false;
  }

  // PIN validation (4 to 8 digits)
  bool isValidPin(String pin) {
    return RegExp(r'^\d{4,8}$').hasMatch(pin);
  }

  // PUK validation (8 digits)
  bool isValidPuk(String puk) {
    return RegExp(r'^\d{8}$').hasMatch(puk);
  }

  // Phone number validation
  bool isValidPhoneNumber(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-()]'), '');
    return RegExp(r'^(\+?[1-9]\d{1,14})?[0-9]{7,10}$').hasMatch(cleanPhone);
  }

  // Email validation
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // --- Main Validation Method ---
  // This method unifies all validations and returns error messages
  String? validateField(
      String fieldKey,
      InputType inputType,
      String value,
      AppLocalizations localizations
      ) {
    if (value.trim().isEmpty) {
      return localizations.required_field;
    }

    // Specific validations by field type
    switch (fieldKey.toLowerCase()) {
      case 'pin':
        return isValidPin(value)
            ? null
            : localizations.verify_entered_data; // "PIN must have 4 digits"

      case 'puk':
        return isValidPuk(value)
            ? null
            : localizations.verify_entered_data; // "PUK must have 8 digits"

      case 'phone':
      case 'phone_number':
        return isValidPhoneNumber(value)
            ? null
            : localizations.verify_entered_data; // "Invalid phone format"
    }

    // Validations by input type
    switch (inputType) {
      case InputType.email:
        return isValidEmail(value)
            ? null
            : localizations.invalid_email;

      case InputType.phone:
        return isValidPhoneNumber(value)
            ? null
            : localizations.verify_entered_data;

      default:
        return null; // Valid field
    }
  }

  // Convenience method for simple validation (boolean)
  bool isValidField(String fieldKey, String value) {
    switch (fieldKey.toLowerCase()) {
      case 'pin':
        return isValidPin(value);
      case 'puk':
        return isValidPuk(value);
      case 'phone':
      case 'phone_number':
        return isValidPhoneNumber(value);
      default:
        return value.trim().isNotEmpty;
    }
  }
}