import 'package:uuid/uuid.dart';
import 'package:cartan/src/models/provider_model.dart';

/// Base class for all cards
abstract class CardModel {
  final String id;
  final Provider provider;
  final String type;
  final String? displayName;
  final String memberId;
  final Map<String, dynamic> metadata;
  final String category;
  final DateTime createdAt;

  CardModel({
    String? id,
    required this.provider,
    required this.type,
    this.displayName,
    required this.memberId,
    this.metadata = const {},
    this.category = 'simple',
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  String get name => displayName ?? provider.displayName;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'providerId': provider.id,
      'providerCategory': provider.category,
      'type': type,
      'displayName': displayName,
      'memberId': memberId,
      'metadata': metadata,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Factory method to create instances based on `type`
  static CardModel fromJson(
      Map<String, dynamic> json, {
        required Provider provider,
      }) {
    final type = json['type'] as String? ?? 'loyalty';
    return typeToClass[type]
        ?.call(json, provider: provider)
        ??
        LoyaltyCard.fromJson(json, provider: provider);
  }
}

/// Loyalty card
class LoyaltyCard extends CardModel {
  LoyaltyCard({
    super.id,
    required super.provider,
    super.displayName,
    required super.memberId,
    super.category,
    super.createdAt,
  }) : super(type: 'loyalty');

  factory LoyaltyCard.fromJson(
      Map<String, dynamic> json, {
        required Provider provider,
      }) {
    return LoyaltyCard(
      id: json['id'] as String?,
      provider: provider,
      displayName: json['displayName'] as String?,
      memberId: json['memberId'] as String? ?? '',
      category: json['category'] as String? ?? 'simple',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}

/// SIM card with specific functionalities
class SimCard extends CardModel {
  SimCard({
    super.id,
    required super.provider,
    super.displayName,
    required super.memberId,
    String? phoneNumber,
    String? pin,
    String? puk,
    super.createdAt,
  }) : super(
    type: 'sim',
    metadata: {
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (pin != null) 'pin': pin,
      if (puk != null) 'puk': puk,
    },
    category: 'simple',
  );

  /// Specific getters for SIM cards
  String? get phoneNumber => metadata['phone_number'] as String?;
  String? get pin => metadata['pin'] as String?;
  String? get puk => metadata['puk'] as String?;

  /// SIM-specific validation
  bool get hasValidPin => pin != null && pin!.isNotEmpty;
  bool get hasValidPuk => puk != null && puk!.isNotEmpty;

  factory SimCard.fromJson(
      Map<String, dynamic> json, {
        required Provider provider,
      }) {
    final metadata = json['metadata'] as Map<String, dynamic>? ?? {};
    return SimCard(
      id: json['id'] as String?,
      provider: provider,
      displayName: json['displayName'] as String?,
      memberId: json['memberId'] as String? ?? '',
      phoneNumber: metadata['phone_number'] as String?,
      pin: metadata['pin'] as String?,
      puk: metadata['puk'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}

/// Business card
class BusinessCard extends CardModel {
  BusinessCard({
    super.id,
    required super.provider,
    super.displayName,
    required super.memberId,
    String? company,
    String? position,
    String? email,
    String? phone,
    String? address,
    super.createdAt,
  }) : super(
    type: 'business',
    metadata: {
      if (company != null) 'company': company,
      if (position != null) 'position': position,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
    },
    category: 'business',
  );

  /// Business-specific getters
  String? get company => metadata['company'] as String?;
  String? get position => metadata['position'] as String?;
  String? get email => metadata['email'] as String?;
  String? get phone => metadata['phone'] as String?;
  String? get address => metadata['address'] as String?;

  /// method combining fields
  String get fullTitle => position != null && company != null
      ? '$position at $company'
      : position ?? company ?? '';

  factory BusinessCard.fromJson(
      Map<String, dynamic> json, {
        required Provider provider,
      }) {
    final metadata = json['metadata'] as Map<String, dynamic>? ?? {};
    return BusinessCard(
      id: json['id'] as String?,
      provider: provider,
      displayName: json['displayName'] as String?,
      memberId: json['memberId'] as String? ?? '',
      company: metadata['company'] as String?,
      position: metadata['position'] as String?,
      email: metadata['email'] as String?,
      phone: metadata['phone'] as String?,
      address: metadata['address'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}

/// Membership card
class MembershipCard extends CardModel {
  MembershipCard({
    super.id,
    required super.provider,
    super.displayName,
    required super.memberId,
    String? memberName,
    String? memberType,
    String? expiryDate,
    super.createdAt,
  }) : super(
    type: 'membership',
    metadata: {
      if (memberName != null) 'memberName': memberName,
      if (memberType != null) 'memberType': memberType,
      if (expiryDate != null) 'expiryDate': expiryDate,
    },
    category: 'membership',
  );

  /// Membership-specific getters
  String? get memberName => metadata['memberName'] as String?;
  String? get memberType => metadata['memberType'] as String?;
  String? get expiryDate => metadata['expiryDate'] as String?;

  bool get isExpired {
    if (expiryDate == null) return false;
    final exp = DateTime.tryParse(expiryDate!);
    return exp == null ? false : DateTime.now().isAfter(exp);
  }

  /// Validate membership ID or name if needed
  bool get hasValidMemberName => memberName != null && memberName!.isNotEmpty;

  factory MembershipCard.fromJson(
      Map<String, dynamic> json, {
        required Provider provider,
      }) {
    final metadata = json['metadata'] as Map<String, dynamic>? ?? {};
    return MembershipCard(
      id: json['id'] as String?,
      provider: provider,
      displayName: json['displayName'] as String?,
      memberId: json['memberId'] as String? ?? '',
      memberName: metadata['memberName'] as String?,
      memberType: metadata['memberType'] as String?,
      expiryDate: metadata['expiryDate'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}

/// Rewards card
class RewardsCard extends CardModel {
  RewardsCard({
    super.id,
    required super.provider,
    super.displayName,
    required super.memberId,
    String? points,
    String? memberName,
    String? tier,
    super.createdAt,
  }) : super(
    type: 'rewards',
    metadata: {
      if (points != null) 'points': points,
      if (memberName != null) 'memberName': memberName,
      if (tier != null) 'tier': tier,
    },
    category: 'rewards',
  );

  /// Rewards-specific getters
  String? get points => metadata['points'] as String?;
  String? get memberName => metadata['memberName'] as String?;
  String? get tier => metadata['tier'] as String?;

  bool get isRedeemable {
    final pts = int.tryParse(points ?? '') ?? 0;
    return pts > 0;
  }

  factory RewardsCard.fromJson(
      Map<String, dynamic> json, {
        required Provider provider,
      }) {
    final metadata = json['metadata'] as Map<String, dynamic>? ?? {};
    return RewardsCard(
      id: json['id'] as String?,
      provider: provider,
      displayName: json['displayName'] as String?,
      memberId: json['memberId'] as String? ?? '',
      points: metadata['points'] as String?,
      memberName: metadata['memberName'] as String?,
      tier: metadata['tier'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}

/// Informative card
class InformativeCard extends CardModel {
  InformativeCard({
    super.id,
    required super.provider,
    super.displayName,
    required super.memberId,
    String? description,
    List<String>? instructions,
    super.createdAt,
  }) : super(
    type: 'informative',
    metadata: {
      if (description != null) 'description': description,
      if (instructions != null) 'instructions': instructions,
    },
    category: 'informative',
  );

  /// Informative-specific getters
  String? get description => metadata['description'] as String?;
  List<String>? get instructions =>
      metadata['instructions'] is List
          ? List<String>.from(metadata['instructions'] as List<dynamic>)
          : null;

  factory InformativeCard.fromJson(
      Map<String, dynamic> json, {
        required Provider provider,
      }) {
    final metadata = json['metadata'] as Map<String, dynamic>? ?? {};
    return InformativeCard(
      id: json['id'] as String?,
      provider: provider,
      displayName: json['displayName'] as String?,
      memberId: json['memberId'] as String? ?? '',
      description: metadata['description'] as String?,
      instructions: metadata['instructions'] != null
          ? List<String>.from(metadata['instructions'] as List<dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}

/// Other card (generic catch-all)
class OtherCard extends CardModel {
  OtherCard({
    super.id,
    required super.provider,
    super.displayName,
    required super.memberId,
    Map<String, dynamic>? extraData,
    super.createdAt,
  }) : super(
    type: 'other',
    metadata: extraData ?? {},
    category: 'other',
  );

  /// All extra data passed in
  Map<String, dynamic>? get extraData => metadata;

  factory OtherCard.fromJson(
      Map<String, dynamic> json, {
        required Provider provider,
      }) {
    final metadata = json['metadata'] as Map<String, dynamic>? ?? {};
    return OtherCard(
      id: json['id'] as String?,
      provider: provider,
      displayName: json['displayName'] as String?,
      memberId: json['memberId'] as String? ?? '',
      extraData: metadata,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}

/// Mapper to facilitate instance creation based on `type`
typedef CardFactoryFunction = CardModel Function(
    Map<String, dynamic> json, {
    required Provider provider,
    });

const Map<String, CardFactoryFunction> typeToClass = {
  'loyalty': LoyaltyCard.fromJson,
  'sim': SimCard.fromJson,
  'business': BusinessCard.fromJson,
  'membership': MembershipCard.fromJson,
  'rewards': RewardsCard.fromJson,
  'informative': InformativeCard.fromJson,
  'other': OtherCard.fromJson,
};

/// Helper class for card creation
class CardHelper {
  static CardModel create({
    required String type,
    required Provider provider,
    String? displayName,
    required String memberId,
    Map<String, dynamic>? extraData,
  }) {
    switch (type.toLowerCase()) {
      case 'sim':
        return SimCard(
          provider: provider,
          displayName: displayName,
          memberId: memberId,
          phoneNumber: extraData?['phone_number'] as String?,
          pin: extraData?['pin'] as String?,
          puk: extraData?['puk'] as String?,
        );
      case 'business':
        return BusinessCard(
          provider: provider,
          displayName: displayName,
          memberId: memberId,
          company: extraData?['company'] as String?,
          position: extraData?['position'] as String?,
          email: extraData?['email'] as String?,
          phone: extraData?['phone'] as String?,
        );
      case 'membership':
        return MembershipCard(
          provider: provider,
          displayName: displayName,
          memberId: memberId,
          memberName: extraData?['memberName'] as String?,
          memberType: extraData?['memberType'] as String?,
          expiryDate: extraData?['expiryDate'] as String?,
        );
      case 'rewards':
        return RewardsCard(
          provider: provider,
          displayName: displayName,
          memberId: memberId,
          points: extraData?['points'] as String?,
          memberName: extraData?['memberName'] as String?,
          tier: extraData?['tier'] as String?,
        );
      case 'informative':
        return InformativeCard(
          provider: provider,
          displayName: displayName,
          memberId: memberId,
          description: extraData?['description'] as String?,
          instructions: extraData?['instructions'] is List
              ? List<String>.from(extraData!['instructions'] as List<dynamic>)
              : null,
        );
      case 'other':
        return OtherCard(
          provider: provider,
          displayName: displayName,
          memberId: memberId,
          extraData: extraData,
        );
      default:
        return LoyaltyCard(
          provider: provider,
          displayName: displayName,
          memberId: memberId,
        );
    }
  }
}
