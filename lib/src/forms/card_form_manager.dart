import 'package:flutter/material.dart';
import 'package:cartan/src/models/card_type_data.dart';
import 'package:cartan/src/models/card_configuration.dart';

/// Manages input controllers and field validation for each card type
class CardFormManager {
  final CardTypeData cardTypeData;
  final CardConfiguration config;
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String?> _errors = {};

  CardFormManager({
    required this.cardTypeData,
    required this.config,
  }) {
    _initializeControllers();
  }

  void _initializeControllers() {
    final fields = config.getFieldsFromMetadata(cardTypeData.metadata);

    for (final field in fields) {
      _controllers[field.key] = TextEditingController(
        text: field.initialValue ?? '',
      );
    }
  }

  /// Returns the controller for a specific field
  TextEditingController? getController(String fieldKey) {
    return _controllers[fieldKey];
  }

  /// Returns all controllers
  Map<String, TextEditingController> get controllers => Map.unmodifiable(_controllers);

  /// Returns the field configurations for this card type
  List<FormFieldConfig> get fields => config.getFieldsFromMetadata(cardTypeData.metadata);

  /// Validates all fields and stores errors
  bool validateAll() {
    _errors.clear();
    bool isValid = true;

    for (final field in fields) {
      final controller = _controllers[field.key];
      final value = controller?.text ?? '';

      if (field.isRequired && value.isEmpty) {
        _errors[field.key] = 'Required field';
        isValid = false;
      }
    }

    return isValid;
  }

  /// Returns the error message for a specific field, if any
  String? getFieldError(String fieldKey) {
    return _errors[fieldKey];
  }

  /// Collects all form data into a map
  Map<String, dynamic> collectData() {
    final data = <String, dynamic>{};

    for (final entry in _controllers.entries) {
      final value = entry.value.text.trim();
      if (value.isNotEmpty) {
        data[entry.key] = value;
      }
    }

    return data;
  }

  /// Clears all field values and errors
  void clearAll() {
    for (final controller in _controllers.values) {
      controller.clear();
    }
    _errors.clear();
  }

  /// Disposes all controllers and clears memory
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    _errors.clear();
  }

  /// Factory method for SIM card form manager
  static CardFormManager forSim({
    required String id,
    required String displayName,
    required List<String> formats,
    required String assetImagePath,
  }) {
    final metadata = {
      'phone_number': true,
      'pin': true,
      'puk': true,
    };

    final cardTypeData = CardTypeData.forSim(
      id: id,
      displayName: displayName,
      formats: formats,
      assetImagePath: assetImagePath,
      metadata: metadata,
    );

    final config = CardConfigurationFactory.getConfiguration('sim');

    return CardFormManager(
      cardTypeData: cardTypeData,
      config: config,
    );
  }

  /// Factory method for Loyalty card form manager
  static CardFormManager forLoyalty({
    required String id,
    required String displayName,
    required List<String> formats,
    required String assetImagePath,
  }) {
    final cardTypeData = CardTypeData.forLoyalty(
      id: id,
      displayName: displayName,
      formats: formats,
      assetImagePath: assetImagePath,
    );

    final config = CardConfigurationFactory.getConfiguration('loyalty');

    return CardFormManager(
      cardTypeData: cardTypeData,
      config: config,
    );
  }

  /// Factory method for Business card form manager
  static CardFormManager forBusiness({
    required String id,
    required String displayName,
    required List<String> formats,
    required String assetImagePath,
  }) {
    final metadata = {
      'name': true,
      'company': true,
      'email': true,
      'phone': true,
      'address': false, // optional
    };

    final cardTypeData = CardTypeData(
      id: id,
      displayName: displayName,
      formats: formats,
      assetImagePath: assetImagePath,
      category: 'business',
      metadata: metadata,
    );

    final config = CardConfigurationFactory.getConfiguration('business');

    return CardFormManager(
      cardTypeData: cardTypeData,
      config: config,
    );
  }

  /// Factory method for Rewards card form manager
  static CardFormManager forRewards({
    required String id,
    required String displayName,
    required List<String> formats,
    required String assetImagePath,
  }) {
    final metadata = {
      'pointsRequired': true,
      'currentPoints': true,
      'rewardDescription': false,
    };

    final cardTypeData = CardTypeData(
      id: id,
      displayName: displayName,
      formats: formats,
      assetImagePath: assetImagePath,
      category: 'rewards',
      metadata: metadata,
    );

    final config = CardConfigurationFactory.getConfiguration('rewards');

    return CardFormManager(
      cardTypeData: cardTypeData,
      config: config,
    );
  }

  /// Factory method for Informative card form manager
  static CardFormManager forInformative({
    required String id,
    required String displayName,
    required List<String> formats,
    required String assetImagePath,
  }) {
    final metadata = {
      'description': true,
      'instructions': false,
    };

    final cardTypeData = CardTypeData(
      id: id,
      displayName: displayName,
      formats: formats,
      assetImagePath: assetImagePath,
      category: 'informative',
      metadata: metadata,
    );

    final config = CardConfigurationFactory.getConfiguration('informative');

    return CardFormManager(
      cardTypeData: cardTypeData,
      config: config,
    );
  }

  /// Factory method for Other card form manager
  static CardFormManager forOther({
    required String id,
    required String displayName,
    required List<String> formats,
    required String assetImagePath,
  }) {
    final metadata = <String, dynamic>{};

    final cardTypeData = CardTypeData(
      id: id,
      displayName: displayName,
      formats: formats,
      assetImagePath: assetImagePath,
      category: 'other',
      metadata: metadata,
    );

    final config = CardConfigurationFactory.getConfiguration('other');

    return CardFormManager(
      cardTypeData: cardTypeData,
      config: config,
    );
  }
}