// Enum for input types
enum InputType {
  text,
  numeric,
  email,
  phone,
  multiline,
  dropdown,
  date,
}

// Class to define a form field
class FormFieldConfig {
  final String key;
  final String labelKey; // For localization
  final bool isRequired;
  final InputType inputType;
  final String? hintKey; // For localization
  final int? maxLength;
  final List<String>? options; // For dropdowns
  final String? initialValue;

  FormFieldConfig({
    required this.key,
    required this.labelKey,
    this.isRequired = false,
    this.inputType = InputType.text,
    this.hintKey,
    this.maxLength,
    this.options,
    this.initialValue,
  });
}

// Abstract base class for card configurations
abstract class CardConfiguration {
  String get cardType;
  List<FormFieldConfig> get additionalFields;
  bool get needsManualEntry;

  // Method to validate entered data
  bool validateData(Map<String, dynamic> data);

  // Method to get fields based on metadata from CardTypeData
  List<FormFieldConfig> getFieldsFromMetadata(Map<String, dynamic>? metadata);
}

// Implementation for loyalty cards
class LoyaltyCardConfig extends CardConfiguration {
  @override
  String get cardType => 'loyalty';

  @override
  List<FormFieldConfig> get additionalFields => [];

  @override
  bool get needsManualEntry => false;

  @override
  bool validateData(Map<String, dynamic> data) {
    return data.containsKey('cardNumber') &&
        data['cardNumber'].toString().isNotEmpty;
  }

  @override
  List<FormFieldConfig> getFieldsFromMetadata(Map<String, dynamic>? metadata) {
    return [];
  }
}

// Implementation for SIM Cards
class SimCardConfig extends CardConfiguration {
  @override
  String get cardType => 'sim';

  @override
  List<FormFieldConfig> get additionalFields => [];

  @override
  bool get needsManualEntry => true;

  @override
  bool validateData(Map<String, dynamic> data) {
    // Validate if at least the card number exists
    if (!data.containsKey('cardNumber') ||
        data['cardNumber'].toString().isEmpty) {
      return false;
    }

    // If PIN is required and exists, validate
    if (data.containsKey('pin') && data['pin'].toString().isNotEmpty) {
      final pin = data['pin'].toString();
      if (pin.length < 4 || pin.length > 8) {
        return false;
      }
    }

    // If PUK is required and exists, validate
    if (data.containsKey('puk') && data['puk'].toString().isNotEmpty) {
      final puk = data['puk'].toString();
      if (puk.length < 8 || puk.length > 8) {
        return false;
      }
    }

    return true;
  }

  @override
  List<FormFieldConfig> getFieldsFromMetadata(Map<String, dynamic>? metadata) {
    if (metadata == null) return [];

    List<FormFieldConfig> fields = [];

    // Map metadata fields to FormFieldConfig
    metadata.forEach((key, value) {
      switch (key.toLowerCase()) {
        case 'phone_number':
          fields.add(FormFieldConfig(
            key: 'phone_number',
            labelKey: 'phone_number',
            inputType: InputType.phone,
            maxLength: 9,
            hintKey: 'phone_number_hint',
          ));
          break;
        case 'pin':
          fields.add(FormFieldConfig(
            key: 'pin',
            labelKey: 'pin_label',
            inputType: InputType.numeric,
            maxLength: 8,
            isRequired: true,
            hintKey: 'pin_hint',
          ));
          break;
        case 'puk':
          fields.add(FormFieldConfig(
            key: 'puk',
            labelKey: 'puk_label',
            inputType: InputType.numeric,
            maxLength: 8,
            isRequired: true,
            hintKey: 'puk_hint',
          ));
          break;
      }
    });

    return fields;
  }
}

// Factory to create configurations
class CardConfigurationFactory {
  static CardConfiguration getConfiguration(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'loyalty':
        return LoyaltyCardConfig();
      case 'sim':
        return SimCardConfig();
      default:
        throw UnsupportedError('Card type $cardType not supported');
    }
  }

  static List<String> get supportedTypes => [
    'loyalty', 'sim'
  ];
}