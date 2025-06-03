abstract class Provider {
  final String id;
  final String displayName;
  final List<String> formats;
  final String assetImagePath;
  final String website;
  final String category;
  final Map<String, dynamic> metadata;

  Provider({
    required this.id,
    required this.displayName,
    required this.formats,
    required this.assetImagePath,
    required this.website,
    required this.category,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'formats': formats,
      'assetImagePath': assetImagePath,
      'website': website,
      'category': category,
      'metadata': metadata,
    };
  }

  // Factory method to create instances based on category
  static Provider fromJson(Map<String, dynamic> json) {
    final category = json['category'] as String;

    return categoryToClass[category.toLowerCase()]?.call(json) ??
        LoyaltyProvider.fromJson(json);
  }
}

// Loyalty provider (most common)
class LoyaltyProvider extends Provider {
  LoyaltyProvider({
    required super.id,
    required super.displayName,
    required super.formats,
    required super.assetImagePath,
    required super.website,
    super.metadata,
  }) : super(
    category: 'loyalty',
  );

  factory LoyaltyProvider.fromJson(Map<String, dynamic> json) {
    return LoyaltyProvider(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      formats: List<String>.from(json['formats'] as List<dynamic>),
      assetImagePath: json['assetImagePath'] as String,
      website: json['website'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  // Loyalty-specific methods
  bool get hasLoyaltyProgram => metadata['hasLoyaltyProgram'] as bool? ?? false;
  String? get loyaltyTier => metadata['loyaltyTier'] as String?;
}

// SIM provider with specific functionalities
class SimProvider extends Provider {
  SimProvider({
    required super.id,
    required super.displayName,
    required super.formats,
    required super.assetImagePath,
    required super.website,
    super.metadata,
  }) : super(
    category: 'sim',
  );

  factory SimProvider.fromJson(Map<String, dynamic> json) {
    return SimProvider(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      formats: List<String>.from(json['formats'] as List<dynamic>),
      assetImagePath: json['assetImagePath'] as String,
      website: json['website'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  // SIM-specific methods
  List<String> get supportedNetworks =>
      List<String>.from(metadata['supportedNetworks'] as List<dynamic>? ?? []);

  String? get networkType => metadata['networkType'] as String?; // 4G, 5G, etc.
  bool get supportsEsim => metadata['supportsEsim'] as bool? ?? false;
  String? get countryCode => metadata['countryCode'] as String?;

  // Helper methods for SIM validation
  bool isValidIccid(String iccid) {
    // Basic ICCID validation (should be 19-20 digits)
    return RegExp(r'^\d{19,20}$').hasMatch(iccid);
  }

  bool isValidMsisdn(String msisdn) {
    // Basic MSISDN validation
    return RegExp(r'^\+?[\d\s-()]+$').hasMatch(msisdn);
  }
}

// Business provider
class BusinessProvider extends Provider {
  BusinessProvider({
    required super.id,
    required super.displayName,
    required super.formats,
    required super.assetImagePath,
    required super.website,
    super.metadata,
  }) : super(
    category: 'business',
  );

  factory BusinessProvider.fromJson(Map<String, dynamic> json) {
    return BusinessProvider(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      formats: List<String>.from(json['formats'] as List<dynamic>),
      assetImagePath: json['assetImagePath'] as String,
      website: json['website'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  // Business-specific methods
  String? get industry => metadata['industry'] as String?;
  String? get businessType => metadata['businessType'] as String?;
  List<String> get services =>
      List<String>.from(metadata['services'] as List<dynamic>? ?? []);

  bool get isB2B => metadata['isB2B'] as bool? ?? false;
  bool get isB2C => metadata['isB2C'] as bool? ?? true;
}

// Credit card provider
class CreditCardProvider extends Provider {
  CreditCardProvider({
    required super.id,
    required super.displayName,
    required super.formats,
    required super.assetImagePath,
    required super.website,
    super.metadata,
  }) : super(
    category: 'credit',
  );

  factory CreditCardProvider.fromJson(Map<String, dynamic> json) {
    return CreditCardProvider(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      formats: List<String>.from(json['formats'] as List<dynamic>),
      assetImagePath: json['assetImagePath'] as String,
      website: json['website'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  // Credit card specific methods
  String? get cardNetwork => metadata['cardNetwork'] as String?; // Visa, Mastercard, etc.
  List<String> get acceptedCurrencies =>
      List<String>.from(metadata['acceptedCurrencies'] as List<dynamic>? ?? ['EUR']);

  bool get hasContactless => metadata['hasContactless'] as bool? ?? true;
  double? get annualFee => (metadata['annualFee'] as num?)?.toDouble();

  // Card number validation based on network
  bool isValidCardNumber(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(RegExp(r'\s|-'), '');

    switch (cardNetwork?.toLowerCase()) {
      case 'visa':
        return RegExp(r'^4\d{15}$').hasMatch(cleanNumber);
      case 'mastercard':
        return RegExp(r'^5[1-5]\d{14}$').hasMatch(cleanNumber);
      case 'amex':
        return RegExp(r'^3[47]\d{13}$').hasMatch(cleanNumber);
      default:
        return RegExp(r'^\d{13,19}$').hasMatch(cleanNumber);
    }
  }
}

// Mapper for provider creation
typedef ProviderFactoryFunction = Provider Function(Map<String, dynamic> json);

const Map<String, ProviderFactoryFunction> categoryToClass = {
  'loyalty': LoyaltyProvider.fromJson,
  'sim': SimProvider.fromJson,
  'business': BusinessProvider.fromJson,
  'credit': CreditCardProvider.fromJson,
};

// Helper class for provider creation
class ProviderHelper {
  static Provider create({
    required String category,
    required String id,
    required String displayName,
    required List<String> formats,
    required String assetImagePath,
    required String website,
    Map<String, dynamic>? metadata,
  }) {
    switch (category.toLowerCase()) {
      case 'sim':
        return SimProvider(
          id: id,
          displayName: displayName,
          formats: formats,
          assetImagePath: assetImagePath,
          website: website,
          metadata: metadata ?? {},
        );
      case 'business':
        return BusinessProvider(
          id: id,
          displayName: displayName,
          formats: formats,
          assetImagePath: assetImagePath,
          website: website,
          metadata: metadata ?? {},
        );
      case 'credit':
        return CreditCardProvider(
          id: id,
          displayName: displayName,
          formats: formats,
          assetImagePath: assetImagePath,
          website: website,
          metadata: metadata ?? {},
        );
      default:
        return LoyaltyProvider(
          id: id,
          displayName: displayName,
          formats: formats,
          assetImagePath: assetImagePath,
          website: website,
          metadata: metadata ?? {},
        );
    }
  }
}

// Extension methods for type checking (if needed)
extension ProviderTypeCheck on Provider {
  bool get isLoyaltyProvider => this is LoyaltyProvider;
  bool get isSimProvider => this is SimProvider;
  bool get isBusinessProvider => this is BusinessProvider;
  bool get isCreditCardProvider => this is CreditCardProvider;
}