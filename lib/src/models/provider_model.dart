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
    return categoryToClass[category.toLowerCase()]?.call(json)
        ?? LoyaltyProvider.fromJson(json);
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
  }) : super(category: 'loyalty');

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
  }) : super(category: 'sim');

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
  bool isValidCardNumber(String cardNumber) {
    // Basic validation (19-20 digits)
    return RegExp(r'^\d{19,20}$').hasMatch(cardNumber);
  }

  bool isValidPhoneNumber(String phoneNumber) {
    // Basic phone_number validation
    return RegExp(r'^\+?[\d\s\-()]+$').hasMatch(phoneNumber);
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
  }) : super(category: 'business');

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

// Membership provider
class MembershipProvider extends Provider {
  MembershipProvider({
    required super.id,
    required super.displayName,
    required super.formats,
    required super.assetImagePath,
    required super.website,
    super.metadata,
  }) : super(category: 'membership');

  factory MembershipProvider.fromJson(Map<String, dynamic> json) {
    return MembershipProvider(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      formats: List<String>.from(json['formats'] as List<dynamic>),
      assetImagePath: json['assetImagePath'] as String,
      website: json['website'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  // Membership-specific metadata getters
  String? get membershipId => metadata['membershipId'] as String?;
  String? get expirationDate => metadata['expirationDate'] as String?;
  String? get membershipLevel => metadata['membershipLevel'] as String?;
  String? get memberSince => metadata['memberSince'] as String?;

  bool get isExpired {
    if (expirationDate == null) return false;
    final exp = DateTime.tryParse(expirationDate!);
    return exp == null ? false : DateTime.now().isAfter(exp);
  }

  // Membership ID validation
  bool isValidMembershipId(String id) {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(id) && id.isNotEmpty;
  }
}

// Rewards provider
class RewardsProvider extends Provider {
  RewardsProvider({
    required super.id,
    required super.displayName,
    required super.formats,
    required super.assetImagePath,
    required super.website,
    super.metadata,
  }) : super(category: 'rewards');

  factory RewardsProvider.fromJson(Map<String, dynamic> json) {
    return RewardsProvider(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      formats: List<String>.from(json['formats'] as List<dynamic>),
      assetImagePath: json['assetImagePath'] as String,
      website: json['website'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  // Rewards-specific metadata getters
  int? get pointsRequired => (metadata['pointsRequired'] as int?)?.toInt();
  int? get currentPoints => (metadata['currentPoints'] as int?)?.toInt();
  String? get rewardDescription => metadata['rewardDescription'] as String?;

  bool get isRedeemable => (currentPoints ?? 0) >= (pointsRequired ?? 0);
}

// Informative provider
class InformativeProvider extends Provider {
  InformativeProvider({
    required super.id,
    required super.displayName,
    required super.formats,
    required super.assetImagePath,
    required super.website,
    super.metadata,
  }) : super(category: 'informative');

  factory InformativeProvider.fromJson(Map<String, dynamic> json) {
    return InformativeProvider(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      formats: List<String>.from(json['formats'] as List<dynamic>),
      assetImagePath: json['assetImagePath'] as String,
      website: json['website'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  // Informative-specific metadata getters
  String? get description => metadata['description'] as String?;
  List<String>? get instructions =>
      List<String>.from(metadata['instructions'] as List<dynamic>? ?? []);
}

// Other provider (generic catch-all)
class OtherProvider extends Provider {
  OtherProvider({
    required super.id,
    required super.displayName,
    required super.formats,
    required super.assetImagePath,
    required super.website,
    super.metadata,
  }) : super(category: 'other');

  factory OtherProvider.fromJson(Map<String, dynamic> json) {
    return OtherProvider(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      formats: List<String>.from(json['formats'] as List<dynamic>),
      assetImagePath: json['assetImagePath'] as String,
      website: json['website'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  // Generic metadata getters
  Map<String, dynamic> get extraData => metadata;
}

// Mapper for provider creation
typedef ProviderFactoryFunction = Provider Function(Map<String, dynamic> json);

const Map<String, ProviderFactoryFunction> categoryToClass = {
  'loyalty': LoyaltyProvider.fromJson,
  'sim': SimProvider.fromJson,
  'business': BusinessProvider.fromJson,
  'membership': MembershipProvider.fromJson,
  'rewards': RewardsProvider.fromJson,
  'informative': InformativeProvider.fromJson,
  'other': OtherProvider.fromJson,
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
      case 'membership':
        return MembershipProvider(
          id: id,
          displayName: displayName,
          formats: formats,
          assetImagePath: assetImagePath,
          website: website,
          metadata: metadata ?? {},
        );
      case 'rewards':
        return RewardsProvider(
          id: id,
          displayName: displayName,
          formats: formats,
          assetImagePath: assetImagePath,
          website: website,
          metadata: metadata ?? {},
        );
      case 'informative':
        return InformativeProvider(
          id: id,
          displayName: displayName,
          formats: formats,
          assetImagePath: assetImagePath,
          website: website,
          metadata: metadata ?? {},
        );
      case 'other':
        return OtherProvider(
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
  bool get isMembershipProvider => this is MembershipProvider;
  bool get isRewardsProvider => this is RewardsProvider;
  bool get isInformativeProvider => this is InformativeProvider;
  bool get isOtherProvider => this is OtherProvider;
}