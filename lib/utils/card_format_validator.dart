import 'package:cartan/src/models/card_configuration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Optimized validator for various card field formats
class CardFormatValidator {
  // Precompiled regex patterns for performance - made static final for better memory usage
  static final Map<String, RegExp> _regexCache = {
    'default': RegExp(r'^[A-Za-z0-9]+$'),
    'pin': RegExp(r'^\d{4,8}$'),
    'puk': RegExp(r'^\d{8}$'),
    'phone_cleanup': RegExp(r'[\s\-()]'),
    'phone': RegExp(r'^(\+?[1-9]\d{1,14})?[0-9]{7,10}$'),
    'email': RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$'),
    'date': RegExp(r'^\d{1,2}/\d{1,2}/\d{4}$|^\d{4}-\d{2}-\d{2}$'),
    'numeric': RegExp(r'^\d+$'),
  };

  // Field normalization - using const for better performance
  static const Map<String, String> _fieldNormalization = {
    'cardnumber': 'card_number',
    'cardNumber': 'card_number',
    'expirydate': 'expiry_date',
    'phone': 'phone_number',
  };

  // Validation type mapping - using const
  static const Map<String, String> _fieldToValidationType = {
    'pin': 'pin',
    'puk': 'puk',
    'phone': 'phone',
    'phone_number': 'phone',
    'email': 'email',
    'expirydate': 'date',
    'expiry_date': 'date',
    'points': 'points',
    'card_number': 'card_number',
    'cardnumber': 'card_number',
  };

  // Getter methods for regex patterns
  RegExp get _defaultRegex => _regexCache['default']!;
  RegExp get _pinRegex => _regexCache['pin']!;
  RegExp get _pukRegex => _regexCache['puk']!;
  RegExp get _phoneCleanupRegex => _regexCache['phone_cleanup']!;
  RegExp get _phoneRegex => _regexCache['phone']!;
  RegExp get _emailRegex => _regexCache['email']!;
  RegExp get _dateRegex => _regexCache['date']!;
  RegExp get _numericRegex => _regexCache['numeric']!;

  /// Validate against a list of regex patterns or use default alphanumeric
  bool isValidFormat(String input, List<String> formats) {
    if (input.isEmpty) return false;
    if (formats.isEmpty) {
      return _defaultRegex.hasMatch(input);
    }
    return formats.any((pattern) => RegExp(pattern).hasMatch(input));
  }

  /// Optimized validation methods using cached regex
  bool isValidPin(String pin) => pin.isNotEmpty && _pinRegex.hasMatch(pin);
  bool isValidPuk(String puk) => puk.isNotEmpty && _pukRegex.hasMatch(puk);
  bool isValidEmail(String email) => email.isNotEmpty && _emailRegex.hasMatch(email);
  bool isValidNumeric(String value) => value.isNotEmpty && _numericRegex.hasMatch(value);
  bool isValidPoints(String points) => isValidNumeric(points);

  /// Phone number validation (after cleaning separators)
  bool isValidPhoneNumber(String phone) {
    if (phone.isEmpty) return false;
    final cleaned = phone.replaceAll(_phoneCleanupRegex, '');
    return _phoneRegex.hasMatch(cleaned);
  }

  /// Date validation with improved error handling
  bool isValidDate(String date) {
    if (date.isEmpty || !_dateRegex.hasMatch(date)) return false;

    try {
      final normalizedDate = date.contains('/')
          ? date.split('/').reversed.join('-')
          : date;
      DateTime.parse(normalizedDate);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Card number validation (non-empty alphanumeric)
  bool isValidCardNumber(String number) {
    final trimmed = number.trim();
    return trimmed.isNotEmpty && _defaultRegex.hasMatch(trimmed);
  }

  /// Main field validation with improved performance
  String? validateField(
      String fieldKey,
      String value,
      AppLocalizations localizations, {
        String? cardType,
        InputType? inputType,
        bool isRequired = true,
      }) {
    final trimmed = value.trim();

    // Early return for optional empty fields
    if (!isRequired && trimmed.isEmpty) return null;

    // Required field validation
    if (isRequired && trimmed.isEmpty) {
      return localizations.required_field;
    }

    // Normalize field key once
    final normalizedKey = _fieldNormalization[fieldKey.toLowerCase()] ?? fieldKey.toLowerCase();

    // Combined validation approach - check field name and input type together
    return _validateFieldContent(normalizedKey, trimmed, cardType, inputType, localizations);
  }

  /// Unified validation logic
  String? _validateFieldContent(
      String key,
      String value,
      String? cardType,
      InputType? inputType,
      AppLocalizations localizations,
      ) {
    // Primary validation by field name
    final validator = _getValidatorForField(key, inputType);
    if (validator != null && !validator(value)) {
      final validationType = _fieldToValidationType[key] ?? _getValidationTypeFromInputType(inputType);
      return _getErrorMessage(validationType, cardType, localizations);
    }

    return null;
  }

  /// Get appropriate validator function for field
  bool Function(String)? _getValidatorForField(String key, InputType? inputType) {
    switch (key) {
      case 'pin': return isValidPin;
      case 'puk': return isValidPuk;
      case 'phone_number': return isValidPhoneNumber;
      case 'card_number': return isValidCardNumber;
      case 'points': return isValidPoints;
      case 'expiry_date': return isValidDate;
      case 'email': return isValidEmail;
      default:
      // Fallback to input type validation
        return _getValidatorForInputType(inputType);
    }
  }

  /// Get validator based on input type
  bool Function(String)? _getValidatorForInputType(InputType? type) {
    switch (type) {
      case InputType.email: return isValidEmail;
      case InputType.phone: return isValidPhoneNumber;
      case InputType.numeric: return isValidNumeric;
      case InputType.date: return isValidDate;
      default: return null;
    }
  }

  /// Get validation type from input type
  String _getValidationTypeFromInputType(InputType? type) {
    switch (type) {
      case InputType.email: return 'email';
      case InputType.phone: return 'phone';
      case InputType.numeric: return 'numeric';
      case InputType.date: return 'date';
      default: return 'generic';
    }
  }

  /// Optimized error message generation
  String _getErrorMessage(
      String validationType,
      String? cardType,
      AppLocalizations localizations,
      ) {
    final ct = cardType?.toLowerCase();

    switch (validationType) {
      case 'pin':
        return ct == 'sim' ? localizations.pin_hint : localizations.pin_hint;
      case 'puk':
        return ct == 'sim'
            ? localizations.puk_hint
            : localizations.puk_hint;
      case 'phone':
        return switch (ct) {
          'sim' => localizations.invalid_phone_number,
          _ => localizations.invalid_phone_number,
        };
      case 'card_number':
        return switch (ct) {
          'sim' => localizations.invalid_card_not_empty_alphanumeric,
          _ => localizations.verify_entered_data,
        };
      default: return localizations.verify_entered_data;
    }
  }

  // Card data validation
  Map<String, String> validateCardData(
      String cardType,
      Map<String, dynamic> data,
      AppLocalizations localizations,
      ) {
    final errors = <String, String>{};

    // Validate cardNumber:
    if (!data.containsKey('cardNumber')) {
      errors['cardNumber'] = localizations.required_field;
    } else if (!isValidCardNumber(data['cardNumber'].toString())) {
      errors['cardNumber'] = localizations.invalid_card_format;
    }


    // Card-specific validation using strategy pattern
    final validator = _getCardValidator(cardType.toLowerCase());
    if (validator != null) {
      validator(data, errors, localizations);
    }

    return errors;
  }

  /// Strategy pattern for card-specific validation
  void Function(Map<String, dynamic>, Map<String, String>, AppLocalizations)? _getCardValidator(String cardType) {
    switch (cardType) {
      case 'sim': return _validateSimCard;
      case 'business': return _validateBusinessCard;
      case 'membership': return _validateMembershipCard;
      case 'rewards': return _validateRewardsCard;
      case 'informative': return _validateInformativeCard;
      default: return null;
    }
  }

  // Card-specific validation methods
  void _validateSimCard(
      Map<String, dynamic> data,
      Map<String, String> errors,
      AppLocalizations localizations,
      ) {
    _validateOptionalField(data, errors, 'pin', isValidPin, 'pin', 'sim', localizations);
    _validateOptionalField(data, errors, 'puk', isValidPuk, 'puk', 'sim', localizations);
    _validateOptionalField(data, errors, 'phone_number', isValidPhoneNumber, 'phone', 'sim', localizations);
  }

  void _validateBusinessCard(
      Map<String, dynamic> data,
      Map<String, String> errors,
      AppLocalizations localizations,
      ) {
    _validateOptionalField(data, errors, 'email', isValidEmail, 'email', 'business', localizations);
    _validateOptionalField(data, errors, 'phone', isValidPhoneNumber, 'phone', 'business', localizations);
  }

  void _validateMembershipCard(
      Map<String, dynamic> data,
      Map<String, String> errors,
      AppLocalizations localizations,
      ) {
    _validateOptionalField(data, errors, 'expiryDate', isValidDate, 'date', 'membership', localizations);
  }

  void _validateRewardsCard(
      Map<String, dynamic> data,
      Map<String, String> errors,
      AppLocalizations localizations,
      ) {
    _validateOptionalField(data, errors, 'points', isValidPoints, 'points', 'rewards', localizations);
  }

  void _validateInformativeCard(
      Map<String, dynamic> data,
      Map<String, String> errors,
      AppLocalizations localizations,
      ) {
    if (data.containsKey('description') &&
        data['description'].toString().trim().isEmpty) {
      errors['description'] = 'Description cannot be empty';
    }
  }

  /// Simplified optional field validation
  void _validateOptionalField(
      Map<String, dynamic> data,
      Map<String, String> errors,
      String fieldKey,
      bool Function(String) validator,
      String validationType,
      String cardType,
      AppLocalizations localizations,
      ) {
    final input = data[fieldKey]?.toString() ?? '';
    if (input.isNotEmpty && !validator(input)) {
      errors[fieldKey] = _getErrorMessage(validationType, cardType, localizations);
    }
  }
}