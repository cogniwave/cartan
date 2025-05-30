import 'package:uuid/uuid.dart';
import 'package:cartan/src/models/provider_model.dart';

class LoyaltyCard {
  final String id;
  final Provider provider;
  final String type;
  final String? displayName;
  final String memberId;
  final Map<String, dynamic> metadata;
  final String category;
  final DateTime createdAt;

  LoyaltyCard({
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

  // Helper methods SIM card
  String? get iccid => metadata['iccid'] as String?;
  String? get msisdn => metadata['msisdn'] as String?;
  String? get pin => metadata['pin'] as String?;
  String? get puk => metadata['puk'] as String?;

  factory LoyaltyCard.fromJson(
      Map<String, dynamic> json, {
        required Provider provider,
      }) {
    return LoyaltyCard(
      id: json['id'] as String?,
      provider: provider,
      type: json['type'] as String? ?? 'membership',
      displayName: json['displayName'] as String?,
      memberId: json['memberId'] as String? ?? '',
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
      category: json['category'] as String? ?? 'simple',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
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
    return data;
  }

  // Factory methods for different types
  factory LoyaltyCard.forLoyalty({
    String? id,
    required Provider provider,
    String? displayName,
    required String memberId,
    String category = 'simple',
  }) {
    return LoyaltyCard(
      id: id,
      provider: provider,
      type: 'membership',
      displayName: displayName,
      memberId: memberId,
      category: category,
    );
  }

  factory LoyaltyCard.forSim({
    String? id,
    required Provider provider,
    String? displayName,
    required String memberId,
    String? iccid,
    String? msisdn,
    String? pin,
    String? puk,
  }) {
    final metadata = <String, dynamic>{};
    if (iccid != null) metadata['iccid'] = iccid;
    if (msisdn != null) metadata['msisdn'] = msisdn;
    if (pin != null) metadata['pin'] = pin;
    if (puk != null) metadata['puk'] = puk;

    return LoyaltyCard(
      id: id,
      provider: provider,
      type: 'Sim',
      displayName: displayName,
      memberId: memberId,
      metadata: metadata,
      category: 'simple',
    );
  }
}