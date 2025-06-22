import 'package:cartan/utils/card_format_validator.dart';
import 'package:cartan/l10n/app_localizations.dart';

// Enum input types
enum InputType { text, numeric, email, phone, multiline, dropdown, date }

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

  final List<String> formats;
  final Map<String, dynamic>? metadata;

  CardConfiguration({required this.formats, required this.metadata});

  String get cardType;
  bool get needsManualEntry;

  List<FormFieldConfig> getFieldsFromMetadata();

  bool isDataValid(Map<String, dynamic> data, AppLocalizations localizations) {
    return _validator.validateCardData(cardType, data, localizations).isEmpty;
  }

  Map<String, String> getDataValidationErrors(
    Map<String, dynamic> data,
    AppLocalizations localizations,
  ) {
    return _validator.validateCardData(cardType, data, localizations);
  }
}

// Loyalty Card

class LoyaltyCardConfig extends CardConfiguration {
  LoyaltyCardConfig({required super.formats, required super.metadata});

  @override
  String get cardType => 'loyalty';

  @override
  bool get needsManualEntry => true;

  @override
  List<FormFieldConfig> getFieldsFromMetadata() {
    return [
      FormFieldConfig(
        key: 'card_number',
        labelKey: 'card_number',
        inputType: InputType.text,
        maxLength: CardFormatValidator.getMaxLengthFromFormats(formats),
        isRequired: true,
        hintKey: 'card_number_hint',
      ),
    ];
  }
}

// Sim Card

class SimCardConfig extends CardConfiguration {
  SimCardConfig({required super.formats, required super.metadata});

  @override
  String get cardType => 'sim';

  @override
  bool get needsManualEntry => true;

  @override
  List<FormFieldConfig> getFieldsFromMetadata() {
    final fields = <FormFieldConfig>[];

    // card_number
    fields.add(
      FormFieldConfig(
        key: 'card_number',
        labelKey: 'card_number',
        inputType: InputType.text,
        maxLength: CardFormatValidator.getMaxLengthFromFormats(formats),
        isRequired: false,
        hintKey: 'card_number_hint',
      ),
    );

    metadata?.forEach((key, _) {
      switch (key.toLowerCase()) {
        case 'phone_number':
          fields.add(
            FormFieldConfig(
              key: 'phone_number',
              labelKey: 'phone_number',
              inputType: InputType.phone,
              maxLength: 15,
              hintKey: 'phone_number_hint',
            ),
          );
          break;
        case 'pin':
          fields.add(
            FormFieldConfig(
              key: 'pin',
              labelKey: 'pin_label',
              inputType: InputType.numeric,
              maxLength: 8,
              isRequired: true,
              hintKey: 'pin_hint',
            ),
          );
          break;
        case 'puk':
          fields.add(
            FormFieldConfig(
              key: 'puk',
              labelKey: 'puk_label',
              inputType: InputType.numeric,
              maxLength: 8,
              isRequired: true,
              hintKey: 'puk_hint',
            ),
          );
          break;
      }
    });

    return fields;
  }
}

// Business Card

class BusinessCardConfig extends CardConfiguration {
  BusinessCardConfig({required super.formats, required super.metadata});

  @override
  String get cardType => 'business';

  @override
  bool get needsManualEntry => true;

  @override
  List<FormFieldConfig> getFieldsFromMetadata() {
    final fields = <FormFieldConfig>[];

    // card_number
    fields.add(
      FormFieldConfig(
        key: 'card_number',
        labelKey: 'card_number',
        inputType: InputType.text,
        maxLength: CardFormatValidator.getMaxLengthFromFormats(formats),
        isRequired: false,
        hintKey: 'card_number_hint',
      ),
    );

    metadata?.forEach((key, _) {
      switch (key.toLowerCase()) {
        case 'company':
          fields.add(
            FormFieldConfig(
              key: 'company',
              labelKey: 'company_label',
              inputType: InputType.text,
              maxLength: 100,
              hintKey: 'company_hint',
            ),
          );
          break;
        case 'position':
          fields.add(
            FormFieldConfig(
              key: 'position',
              labelKey: 'position_label',
              inputType: InputType.text,
              maxLength: 100,
              hintKey: 'position_hint',
            ),
          );
          break;
        case 'email':
          fields.add(
            FormFieldConfig(
              key: 'email',
              labelKey: 'email_label',
              inputType: InputType.email,
              maxLength: 100,
              hintKey: 'email_hint',
            ),
          );
          break;
        case 'phone':
          fields.add(
            FormFieldConfig(
              key: 'phone',
              labelKey: 'phone_label',
              inputType: InputType.phone,
              maxLength: 15,
              hintKey: 'phone_hint',
            ),
          );
          break;
        case 'address':
          fields.add(
            FormFieldConfig(
              key: 'address',
              labelKey: 'address_label',
              inputType: InputType.multiline,
              maxLength: 200,
              hintKey: 'address_hint',
            ),
          );
          break;
      }
    });

    return fields;
  }
}

// Membership Card

class MembershipCardConfig extends CardConfiguration {
  MembershipCardConfig({required super.formats, required super.metadata});

  @override
  String get cardType => 'membership';

  @override
  bool get needsManualEntry => true;

  @override
  List<FormFieldConfig> getFieldsFromMetadata() {
    final fields = <FormFieldConfig>[];

    metadata?.forEach((key, _) {
      switch (key.toLowerCase()) {
        case 'membername':
          fields.add(
            FormFieldConfig(
              key: 'memberName',
              labelKey: 'member_name_label',
              inputType: InputType.text,
              maxLength: 100,
              isRequired: true,
              hintKey: 'member_name_hint',
            ),
          );
          break;
        case 'membertype':
          fields.add(
            FormFieldConfig(
              key: 'memberType',
              labelKey: 'member_type_label',
              inputType: InputType.text,
              maxLength: 50,
              hintKey: 'member_type_hint',
            ),
          );
          break;
        case 'expirydate':
          fields.add(
            FormFieldConfig(
              key: 'expiryDate',
              labelKey: 'expiry_date_label',
              inputType: InputType.date,
              hintKey: 'expiry_date_hint',
            ),
          );
          break;
      }
    });

    return fields;
  }
}

// Rewards Card

class RewardsCardConfig extends CardConfiguration {
  RewardsCardConfig({required super.formats, required super.metadata});

  @override
  String get cardType => 'rewards';

  @override
  bool get needsManualEntry => true;

  @override
  List<FormFieldConfig> getFieldsFromMetadata() {
    final fields = <FormFieldConfig>[];

    metadata?.forEach((key, _) {
      switch (key.toLowerCase()) {
        case 'points':
          fields.add(
            FormFieldConfig(
              key: 'points',
              labelKey: 'points_label',
              inputType: InputType.numeric,
              maxLength: 10,
              hintKey: 'points_hint',
            ),
          );
          break;
        case 'membername':
          fields.add(
            FormFieldConfig(
              key: 'memberName',
              labelKey: 'member_name_label',
              inputType: InputType.text,
              maxLength: 100,
              hintKey: 'member_name_hint',
            ),
          );
          break;
        case 'tier':
          fields.add(
            FormFieldConfig(
              key: 'tier',
              labelKey: 'tier_label',
              inputType: InputType.text,
              maxLength: 50,
              hintKey: 'tier_hint',
            ),
          );
          break;
      }
    });

    return fields;
  }
}

// Informative Card

class InformativeCardConfig extends CardConfiguration {
  InformativeCardConfig({required super.formats, required super.metadata});

  @override
  String get cardType => 'informative';

  @override
  bool get needsManualEntry => true;

  @override
  List<FormFieldConfig> getFieldsFromMetadata() {
    final fields = <FormFieldConfig>[];

    // card_number
    fields.add(
      FormFieldConfig(
        key: 'card_number',
        labelKey: 'card_number',
        inputType: InputType.text,
        maxLength: CardFormatValidator.getMaxLengthFromFormats(formats),
        isRequired: false,
        hintKey: 'card_number_hint',
      ),
    );

    metadata?.forEach((key, _) {
      switch (key.toLowerCase()) {
        case 'description':
          fields.add(
            FormFieldConfig(
              key: 'description',
              labelKey: 'description_label',
              inputType: InputType.multiline,
              maxLength: 500,
              isRequired: true,
              hintKey: 'description_hint',
            ),
          );
          break;
        case 'instructions':
          fields.add(
            FormFieldConfig(
              key: 'instructions',
              labelKey: 'instructions_label',
              inputType: InputType.multiline,
              maxLength: 1000,
              hintKey: 'instructions_hint',
            ),
          );
          break;
      }
    });

    return fields;
  }
}

// Other Card

class OtherCardConfig extends CardConfiguration {
  OtherCardConfig({required super.formats, required super.metadata});

  @override
  String get cardType => 'other';

  @override
  bool get needsManualEntry => false;

  @override
  List<FormFieldConfig> getFieldsFromMetadata() {
    return [
      FormFieldConfig(
        key: 'card_number',
        labelKey: 'card_number',
        inputType: InputType.text,
        maxLength: CardFormatValidator.getMaxLengthFromFormats(formats),
        isRequired: false,
        hintKey: 'card_number_hint',
      ),
    ];
  }
}

// Factory
class CardConfigurationFactory {
  // Cache configurations by card ID to ensure each card uses its own formats
  static final Map<String, CardConfiguration> _cacheById = {};

  //Creates or retrieves a CardConfiguration based on the full card JSON.
  //Caches instances by the card's "id" field to ensure per-card settings.
  static CardConfiguration fromJson(Map<String, dynamic> cardJson) {
    // Extract the unique card ID
    final id = cardJson['id'] as String;

    // Return cached config if available
    if (_cacheById.containsKey(id)) {
      return _cacheById[id]!;
    }

    // Parse formats and metadata from JSON
    final formats =
        (cardJson['formats'] as List<dynamic>?)?.cast<String>() ?? <String>[];
    final metadata = cardJson['metadata'] as Map<String, dynamic>?;

    // Determine category for selecting the right subclass
    final category = (cardJson['category'] as String).toLowerCase();

    // Instantiate the correct CardConfiguration subclass
    late final CardConfiguration config;
    switch (category) {
      case 'loyalty':
        config = LoyaltyCardConfig(formats: formats, metadata: metadata);
        break;
      case 'sim':
        config = SimCardConfig(formats: formats, metadata: metadata);
        break;
      case 'business':
        config = BusinessCardConfig(formats: formats, metadata: metadata);
        break;
      case 'membership':
        config = MembershipCardConfig(formats: formats, metadata: metadata);
        break;
      case 'rewards':
        config = RewardsCardConfig(formats: formats, metadata: metadata);
        break;
      case 'informative':
        config = InformativeCardConfig(formats: formats, metadata: metadata);
        break;
      case 'other':
        config = OtherCardConfig(formats: formats, metadata: metadata);
        break;
      default:
        throw UnsupportedError('Card type $category not supported');
    }

    // Cache and return the new configuration
    _cacheById[id] = config;
    return config;
  }

  static List<String> get supportedTypes => [
    'loyalty',
    'sim',
    'business',
    'membership',
    'rewards',
    'informative',
    'other',
  ];

  static bool isTypeSupported(String cardType) {
    return supportedTypes.contains(cardType.toLowerCase());
  }

  //Clears all cached configurations
  static void clearCache() {
    _cacheById.clear();
  }
}
