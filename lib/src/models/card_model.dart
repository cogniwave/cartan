import 'package:uuid/uuid.dart';
import 'package:cartan/src/models/provider_model.dart';

// Base class
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

  // Factory method to create instances based on type
  static CardModel fromJson(Map<String, dynamic> json, {required Provider provider}) {
    final type = json['type'] as String? ?? 'loyalty';

    return typeToClass[type]?.call(json, provider: provider) ??
        LoyaltyCard.fromJson(json, provider: provider);
  }
}

// Loyalty card
class LoyaltyCard extends CardModel {
  LoyaltyCard({
    super.id,
    required super.provider,
    super.displayName,
    required super.memberId,
    super.category,
    super.createdAt,
  }) : super(
    type: 'loyalty',
  );

  factory LoyaltyCard.fromJson(Map<String, dynamic> json, {required Provider provider}) {
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

// SIM card with specific functionalities
class SimCard extends CardModel {
  SimCard({
    super.id,
    required super.provider,
    super.displayName,
    required super.memberId,
    String? iccid,
    String? msisdn,
    String? pin,
    String? puk,
    super.createdAt,
  }) : super(
    type: 'sim',
    metadata: {
      if (iccid != null) 'iccid': iccid,
      if (msisdn != null) 'msisdn': msisdn,
      if (pin != null) 'pin': pin,
      if (puk != null) 'puk': puk,
    },
    category: 'simple',
  );

  // Specific getters for SIM cards
  String? get iccid => metadata['iccid'] as String?;
  String? get msisdn => metadata['msisdn'] as String?;
  String? get pin => metadata['pin'] as String?;
  String? get puk => metadata['puk'] as String?;

  // Specific methods for SIM cards
  bool get hasValidPin => pin != null && pin!.isNotEmpty;
  bool get hasValidPuk => puk != null && puk!.isNotEmpty;

  factory SimCard.fromJson(Map<String, dynamic> json, {required Provider provider}) {
    final metadata = json['metadata'] as Map<String, dynamic>? ?? {};

    return SimCard(
      id: json['id'] as String?,
      provider: provider,
      displayName: json['displayName'] as String?,
      memberId: json['memberId'] as String? ?? '',
      iccid: metadata['iccid'] as String?,
      msisdn: metadata['msisdn'] as String?,
      pin: metadata['pin'] as String?,
      puk: metadata['puk'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}

// Business card
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
    super.createdAt,
  }) : super(
    type: 'business',
    metadata: {
      if (company != null) 'company': company,
      if (position != null) 'position': position,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
    },
    category: 'business',
  );

  // Specific getters for business cards
  String? get company => metadata['company'] as String?;
  String? get position => metadata['position'] as String?;
  String? get email => metadata['email'] as String?;
  String? get phone => metadata['phone'] as String?;

  // Specific methods for business cards
  String get fullTitle => position != null && company != null
      ? '$position at $company'
      : position ?? company ?? '';

  factory BusinessCard.fromJson(Map<String, dynamic> json, {required Provider provider}) {
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
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}

// Mapper to facilitate instance creation
typedef CardFactoryFunction = CardModel Function(Map<String, dynamic> json, {required Provider provider});

const Map<String, CardFactoryFunction> typeToClass = {
  'loyalty': LoyaltyCard.fromJson,
  'sim': SimCard.fromJson,
  'business': BusinessCard.fromJson,
};

// Helper class for card creation
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
          iccid: extraData?['iccid'],
          msisdn: extraData?['msisdn'],
          pin: extraData?['pin'],
          puk: extraData?['puk'],
        );
      case 'business':
        return BusinessCard(
          provider: provider,
          displayName: displayName,
          memberId: memberId,
          company: extraData?['company'],
          position: extraData?['position'],
          email: extraData?['email'],
          phone: extraData?['phone'],
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