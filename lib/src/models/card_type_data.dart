import 'package:flutter/material.dart';

class CardTypeData {
  final String? id;
  final String? displayName;
  final List<String>? formats;
  final String? assetImagePath;
  final String? website;
  final String? category;
  final Map<String, dynamic>? metadata;

  // SIM Card controllers
  final TextEditingController? iccidController;
  final TextEditingController? msisdnController;
  final TextEditingController? pinController;
  final TextEditingController? pukController;

  // Business card controllers
  final TextEditingController? nameController;
  final TextEditingController? companyController;
  final TextEditingController? emailController;
  final TextEditingController? phoneController;
  final TextEditingController? addressController;

  // Membership card controllers

  // Information card controllers

  // Rewards card controllers

  CardTypeData({
    // Card info
    this.id,
    this.displayName,
    this.formats,
    this.assetImagePath,
    this.website,
    this.category,
    this.metadata,

    // SIM Card
    this.iccidController,
    this.msisdnController,
    this.pinController,
    this.pukController,

    // Business card
    this.nameController,
    this.companyController,
    this.emailController,
    this.phoneController,
    this.addressController,
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
    TextEditingController? iccidController,
    TextEditingController? msisdnController,
    TextEditingController? pinController,
    TextEditingController? pukController,
  }) {
    return CardTypeData(
      id: id,
      displayName: displayName,
      formats: formats,
      assetImagePath: assetImagePath,
      website: website,
      category: category ?? 'sim',
      metadata: metadata,
      iccidController: iccidController,
      msisdnController: msisdnController,
      pinController: pinController,
      pukController: pukController,
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
}