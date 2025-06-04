class CardTypeData {
  final String? id;
  final String? displayName;
  final List<String>? formats;
  final String? assetImagePath;
  final String? website;
  final String? category;
  final Map<String, dynamic>? metadata;

  CardTypeData({
    this.id,
    this.displayName,
    this.formats,
    this.assetImagePath,
    this.website,
    this.category,
    this.metadata,
  });

  // Factory constructors
  factory CardTypeData.forSim({
    String? id,
    String? displayName,
    List<String>? formats,
    String? assetImagePath,
    String? website,
    String? category,
    Map<String, dynamic>? metadata,
  }) {
    return CardTypeData(
      id: id,
      displayName: displayName,
      formats: formats,
      assetImagePath: assetImagePath,
      website: website,
      category: category ?? 'sim',
      metadata: metadata,
    );
  }

  factory CardTypeData.forLoyalty({
    String? id,
    String? displayName,
    List<String>? formats,
    String? assetImagePath,
    String? website,
    String? category,
    Map<String, dynamic>? metadata,
  }) {
    return CardTypeData(
      id: id,
      displayName: displayName,
      formats: formats,
      assetImagePath: assetImagePath,
      website: website,
      category: category ?? 'loyalty',
      metadata: metadata,
    );
  }

  factory CardTypeData.forBusiness({
    String? id,
    String? displayName,
    List<String>? formats,
    String? assetImagePath,
    String? website,
    String? category,
    Map<String, dynamic>? metadata,
  }) {
    return CardTypeData(
      id: id,
      displayName: displayName,
      formats: formats,
      assetImagePath: assetImagePath,
      website: website,
      category: category ?? 'business',
      metadata: metadata,
    );
  }

  factory CardTypeData.forMembership({
    String? id,
    String? displayName,
    List<String>? formats,
    String? assetImagePath,
    String? website,
    String? category,
    Map<String, dynamic>? metadata,
  }) {
    return CardTypeData(
      id: id,
      displayName: displayName,
      formats: formats,
      assetImagePath: assetImagePath,
      website: website,
      category: category ?? 'membership',
      metadata: metadata,
    );
  }

  factory CardTypeData.forRewards({
    String? id,
    String? displayName,
    List<String>? formats,
    String? assetImagePath,
    String? website,
    String? category,
    Map<String, dynamic>? metadata,
  }) {
    return CardTypeData(
      id: id,
      displayName: displayName,
      formats: formats,
      assetImagePath: assetImagePath,
      website: website,
      category: category ?? 'rewards',
      metadata: metadata,
    );
  }

  factory CardTypeData.forInformative({
    String? id,
    String? displayName,
    List<String>? formats,
    String? assetImagePath,
    String? website,
    String? category,
    Map<String, dynamic>? metadata,
  }) {
    return CardTypeData(
      id: id,
      displayName: displayName,
      formats: formats,
      assetImagePath: assetImagePath,
      website: website,
      category: category ?? 'informative',
      metadata: metadata,
    );
  }

  factory CardTypeData.forOther({
    String? id,
    String? displayName,
    List<String>? formats,
    String? assetImagePath,
    String? website,
    String? category,
    Map<String, dynamic>? metadata,
  }) {
    return CardTypeData(
      id: id,
      displayName: displayName,
      formats: formats,
      assetImagePath: assetImagePath,
      website: website,
      category: category ?? 'other',
      metadata: metadata,
    );
  }

  factory CardTypeData.fromJson(Map<String, dynamic> json) {
    return CardTypeData(
      id: json['id'],
      displayName: json['displayName'],
      formats: json['formats'] != null ? List<String>.from(json['formats']) : null,
      assetImagePath: json['assetImagePath'],
      website: json['website'],
      category: json['category'],
      metadata: json['metadata'] != null ? Map<String, dynamic>.from(json['metadata']) : null,
    );
  }

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

  bool get isSimCard => category?.toLowerCase() == 'sim';
  bool get isLoyaltyCard => category?.toLowerCase() == 'loyalty';
  bool get isBusinessCard => category?.toLowerCase() == 'business';
  bool get isMembershipCard => category?.toLowerCase() == 'membership';
  bool get isRewardsCard => category?.toLowerCase() == 'rewards';
  bool get isInformativeCard => category?.toLowerCase() == 'informative';
  bool get isOtherCard => category?.toLowerCase() == 'other';

  // Helper method to get required fields for this card type
  List<String> get requiredFields {
    switch (category?.toLowerCase()) {
      case 'sim':
        return ['cardNumber', 'phone_number', 'pin', 'puk'];
      case 'business':
        return ['cardNumber', 'name', 'company', 'email', 'phone'];
      case 'membership':
        return ['cardNumber', 'memberName'];
      case 'rewards':
        return ['cardNumber', 'points'];
      case 'informative':
        return ['cardNumber', 'description'];
      case 'other':
        return ['cardNumber'];
      default:
        return ['cardNumber'];
    }
  }
}