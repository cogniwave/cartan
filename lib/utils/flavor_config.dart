import 'package:flutter/material.dart';

// Define an enum for every environment
enum Flavor { prod, staging, dev }

class FlavorValues {
  final String apiBaseUrl;
  final String appIcon;
  final String appName;

  FlavorValues({
    required this.apiBaseUrl,
    required this.appIcon,
    required this.appName,
  });
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final Color color;
  final FlavorValues values;
  static late FlavorConfig _instance;

  factory FlavorConfig({
    required Flavor flavor,
    Color color = Colors.blue,
    required FlavorValues values,
  }) {
    _instance = FlavorConfig._internal(flavor, flavor.name, color, values);
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.name, this.color, this.values);

  static FlavorConfig get instance {
    return _instance;
  }

  // Method to check current environment
  static bool isDevelopment() => _instance.flavor == Flavor.dev;

  static bool isStaging() => _instance.flavor == Flavor.staging;

  static bool isProduction() => _instance.flavor == Flavor.prod;
}