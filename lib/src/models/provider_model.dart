class Provider {
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

  factory Provider.fromJson(Map<String, dynamic> json) {
    // Common fields
    final provider = Provider(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      formats: List<String>.from(json['formats'] as List<dynamic>),
      assetImagePath: json['assetImagePath'] as String,
      website: json['website'] as String,
      category: json['category'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );

    return provider;
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

  // Specific fields
  String? get iccid => metadata['iccid'] as String?;
  String? get msisdn => metadata['msisdn'] as String?;
  String? get pin => metadata['pin'] as String?;
  String? get puk => metadata['puk'] as String?;

  bool get isLoyaltyCard => category.toLowerCase() == 'loyalty';
  bool get isSimCard => category.toLowerCase() == 'sim';
}