import 'package:uuid/uuid.dart';
import 'merchant.dart';

class LoyaltyCard {
  final String id;
  final Merchant merchant;
  final String? displayName;
  final String memberId;
  final String category;
  final DateTime createdAt;

  LoyaltyCard({
    String? id,
    required this.merchant,
    this.displayName,
    required this.memberId,
    this.category = 'simple',
    DateTime? createdAt,
  }) : 
    id = id ?? const Uuid().v4(),
    createdAt = createdAt ?? DateTime.now();

  String get name => displayName ?? merchant.displayName;

  factory LoyaltyCard.fromJson(Map<String, dynamic> json, Merchant merchant) {
    return LoyaltyCard(
      id: json['id'],
      merchant: merchant,
      displayName: json['displayName'],
      memberId: json['memberId'],
      category: json['category'] ?? 'simple',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchantId': merchant.id,
      'displayName': displayName,
      'memberId': memberId,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
