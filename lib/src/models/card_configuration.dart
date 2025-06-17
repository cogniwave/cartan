import 'package:cartan/utils/card_format_validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

abstract class CardConfiguration {
  static final CardFormatValidator _validator = CardFormatValidator();

  String get cardType;
  List<FormFieldConfig> get additionalFields;
  bool get needsManualEntry;

  bool isDataValid(
      Map<String, dynamic> data,
      AppLocalizations localizations,
      ) {
    return _validator
        .validateCardData(cardType, data, localizations)
        .isEmpty;
  }

  Map<String, String> getDataValidationErrors(
      Map<String, dynamic> data,
      AppLocalizations localizations,
      ) {
    return _validator.validateCardData(
      cardType,
      data,
      localizations,
    );
  }

  List<FormFieldConfig> getFieldsFromMetadata(Map<String, dynamic>? metadata);
}

// Loyalty Card
class LoyaltyCardConfig extends CardConfiguration {
  @override
  String get cardType => 'loyalty';

  @override
  List<FormFieldConfig> get additionalFields => [
    FormFieldConfig(
      key: 'card_number',
      labelKey: 'card_number',
      inputType: InputType.text,
      maxLength: 50,
      isRequired: true,
      hintKey: 'card_number_hint',
    ),
  ];

  @override
  bool get needsManualEntry => true;

  @override
  List<FormFieldConfig> getFieldsFromMetadata(Map<String, dynamic>? metadata) {
    return additionalFields;
  }
}

// Sim Card
class SimCardConfig extends CardConfiguration {
  @override
  String get cardType => 'sim';

  @override
  List<FormFieldConfig> get additionalFields => [];

  @override
  bool get needsManualEntry => true;

  @override
  List<FormFieldConfig> getFieldsFromMetadata(Map<String, dynamic>? metadata) {
    if (metadata == null) return [];

    List<FormFieldConfig> fields = [];

    fields.add(FormFieldConfig(
      key: 'card_number',
      labelKey: 'card_number',
      inputType: InputType.text,
      maxLength: 50,
      isRequired: false,
      hintKey: 'card_number_hint',
    ));

    // Map metadata fields to FormFieldConfig
    metadata.forEach((key, value) {
      switch (key.toLowerCase()) {
        case 'phone_number':
          fields.add(FormFieldConfig(
            key: 'phone_number',
            labelKey: 'phone_number',
            inputType: InputType.phone,
            maxLength: 15,
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

// Business Card
class BusinessCardConfig extends CardConfiguration {
  @override
  String get cardType => 'business';

  @override
  List<FormFieldConfig> get additionalFields => [];

  @override
  bool get needsManualEntry => true;

  @override
  List<FormFieldConfig> getFieldsFromMetadata(Map<String, dynamic>? metadata) {
    if (metadata == null) return [];

    List<FormFieldConfig> fields = [];

    fields.add(FormFieldConfig(
      key: 'card_number',
      labelKey: 'card_number',
      inputType: InputType.text,
      maxLength: 50,
      isRequired: false,
      hintKey: 'card_number_hint',
    ));

    metadata.forEach((key, value) {
      switch (key.toLowerCase()) {
        case 'company':
          fields.add(FormFieldConfig(
            key: 'company',
            labelKey: 'company_label',
            inputType: InputType.text,
            maxLength: 100,
            hintKey: 'company_hint',
          ));
          break;
        case 'position':
          fields.add(FormFieldConfig(
            key: 'position',
            labelKey: 'position_label',
            inputType: InputType.text,
            maxLength: 100,
            hintKey: 'position_hint',
          ));
          break;
        case 'email':
          fields.add(FormFieldConfig(
            key: 'email',
            labelKey: 'email_label',
            inputType: InputType.email,
            maxLength: 100,
            hintKey: 'email_hint',
          ));
          break;
        case 'phone':
          fields.add(FormFieldConfig(
            key: 'phone',
            labelKey: 'phone_label',
            inputType: InputType.phone,
            maxLength: 15,
            hintKey: 'phone_hint',
          ));
          break;
        case 'address':
          fields.add(FormFieldConfig(
            key: 'address',
            labelKey: 'address_label',
            inputType: InputType.multiline,
            maxLength: 200,
            hintKey: 'address_hint',
          ));
          break;
      }
    });

    return fields;
  }
}

// Membership Card
class MembershipCardConfig extends CardConfiguration {
  @override
  String get cardType => 'membership';

  @override
  List<FormFieldConfig> get additionalFields => [];

  @override
  bool get needsManualEntry => true;

  @override
  List<FormFieldConfig> getFieldsFromMetadata(Map<String, dynamic>? metadata) {
    if (metadata == null) return [];

    List<FormFieldConfig> fields = [];

    metadata.forEach((key, value) {
      switch (key.toLowerCase()) {
        case 'membername':
          fields.add(FormFieldConfig(
            key: 'memberName',
            labelKey: 'member_name_label',
            inputType: InputType.text,
            maxLength: 100,
            isRequired: true,
            hintKey: 'member_name_hint',
          ));
          break;
        case 'membertype':
          fields.add(FormFieldConfig(
            key: 'memberType',
            labelKey: 'member_type_label',
            inputType: InputType.text,
            maxLength: 50,
            hintKey: 'member_type_hint',
          ));
          break;
        case 'expirydate':
          fields.add(FormFieldConfig(
            key: 'expiryDate',
            labelKey: 'expiry_date_label',
            inputType: InputType.date,
            hintKey: 'expiry_date_hint',
          ));
          break;
      }
    });

    return fields;
  }
}

// Rewards Card
class RewardsCardConfig extends CardConfiguration {
  @override
  String get cardType => 'rewards';

  @override
  List<FormFieldConfig> get additionalFields => [];

  @override
  bool get needsManualEntry => true;

  @override
  List<FormFieldConfig> getFieldsFromMetadata(Map<String, dynamic>? metadata) {
    if (metadata == null) return [];

    List<FormFieldConfig> fields = [];

    metadata.forEach((key, value) {
      switch (key.toLowerCase()) {
        case 'points':
          fields.add(FormFieldConfig(
            key: 'points',
            labelKey: 'points_label',
            inputType: InputType.numeric,
            maxLength: 10,
            hintKey: 'points_hint',
          ));
          break;
        case 'membername':
          fields.add(FormFieldConfig(
            key: 'memberName',
            labelKey: 'member_name_label',
            inputType: InputType.text,
            maxLength: 100,
            hintKey: 'member_name_hint',
          ));
          break;
        case 'tier':
          fields.add(FormFieldConfig(
            key: 'tier',
            labelKey: 'tier_label',
            inputType: InputType.text,
            maxLength: 50,
            hintKey: 'tier_hint',
          ));
          break;
      }
    });

    return fields;
  }
}

// Informative Card
class InformativeCardConfig extends CardConfiguration {
  @override
  String get cardType => 'informative';

  @override
  List<FormFieldConfig> get additionalFields => [];

  @override
  bool get needsManualEntry => true;

  @override
  List<FormFieldConfig> getFieldsFromMetadata(Map<String, dynamic>? metadata) {
    if (metadata == null) return [];

    List<FormFieldConfig> fields = [];

    fields.add(FormFieldConfig(
      key: 'card_number',
      labelKey: 'card_number',
      inputType: InputType.text,
      maxLength: 50,
      isRequired: false,
      hintKey: 'card_number_hint',
    ));

    metadata.forEach((key, value) {
      switch (key.toLowerCase()) {
        case 'description':
          fields.add(FormFieldConfig(
            key: 'description',
            labelKey: 'description_label',
            inputType: InputType.multiline,
            maxLength: 500,
            isRequired: true,
            hintKey: 'description_hint',
          ));
          break;
        case 'instructions':
          fields.add(FormFieldConfig(
            key: 'instructions',
            labelKey: 'instructions_label',
            inputType: InputType.multiline,
            maxLength: 1000,
            hintKey: 'instructions_hint',
          ));
          break;
      }
    });

    return fields;
  }
}

// Other Cards
class OtherCardConfig extends CardConfiguration {
  @override
  String get cardType => 'other';

  @override
  List<FormFieldConfig> get additionalFields => [];

  @override
  bool get needsManualEntry => false;

  @override
  List<FormFieldConfig> getFieldsFromMetadata(Map<String, dynamic>? metadata) {
    return [
      FormFieldConfig(
        key: 'card_number',
        labelKey: 'card_number',
        inputType: InputType.text,
        maxLength: 50,
        isRequired: false,
        hintKey: 'card_number_hint',
      )
    ];
  }
}

class CardConfigurationFactory {
  static final Map<String, CardConfiguration> _cache = {};

  static CardConfiguration getConfiguration(String cardType) {
    final type = cardType.toLowerCase();

    if (_cache.containsKey(type)) {
      return _cache[type]!;
    }

    CardConfiguration config;
    switch (type) {
      case 'loyalty':
        config = LoyaltyCardConfig();
        break;
      case 'sim':
        config = SimCardConfig();
        break;
      case 'business':
        config = BusinessCardConfig();
        break;
      case 'membership':
        config = MembershipCardConfig();
        break;
      case 'rewards':
        config = RewardsCardConfig();
        break;
      case 'informative':
        config = InformativeCardConfig();
        break;
      case 'other':
        config = OtherCardConfig();
        break;
      default:
        throw UnsupportedError('Card type $cardType not supported');
    }

    _cache[type] = config;
    return config;
  }

  static List<String> get supportedTypes => [
    'loyalty', 'sim', 'business', 'membership', 'rewards', 'informative', 'other'
  ];

  static bool isTypeSupported(String cardType) {
    return supportedTypes.contains(cardType.toLowerCase());
  }

  static void clearCache() {
    _cache.clear();
  }
}