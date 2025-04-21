class Merchant {
  final String id;
  final String displayName;
  final List<String> formats;
  final String assetImagePath;
  final String website;
  final String category;

  Merchant({
    required this.id,
    required this.displayName,
    required this.formats,
    required this.assetImagePath,
    required this.website,
    required this.category,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      id: json['id'],
      displayName: json['displayName'],
      formats: List<String>.from(json['formats']),
      assetImagePath: json['assetImagePath'],
      website: json['website'],
      category: json['category'],
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
    };
  }
}
