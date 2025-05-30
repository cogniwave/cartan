import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cartan/src/models/provider_model.dart';


enum ProviderCategory { loyalty, sim }

extension ProviderCategoryExtension on ProviderCategory {
  String get name {
    switch (this) {
      case ProviderCategory.loyalty:
        return 'Loyalty';
      case ProviderCategory.sim:
        return 'Sim';
    }
  }

  String get fileName {
    switch (this) {
      case ProviderCategory.loyalty:
        return 'lib/assets/data/merchants.json';
      case ProviderCategory.sim:
        return 'lib/assets/data/sim_carriers.json';
    }
  }
}

class ProvidersRepository {
  // Cache
  final Map<ProviderCategory, List<Provider>> _cachedProviders = {};

  Future<void> initialize(ProviderCategory category) async {
    if (_cachedProviders.containsKey(category) && _cachedProviders[category]!.isNotEmpty) {
      return;
    }

    // Load from JSON
    final jsonString = await rootBundle.loadString(category.fileName);
    final List<dynamic> jsonList = json.decode(jsonString);
    final providers = jsonList.map((json) => Provider.fromJson(json)).toList();
    _cachedProviders[category] = providers;
  }

  bool isInitialized(ProviderCategory category) {
    return _cachedProviders.containsKey(category) && _cachedProviders[category]!.isNotEmpty;
  }

  List<Provider> getAllProviders(ProviderCategory category) {
    return _cachedProviders[category] ?? [];
  }

  Provider getProviderById(String id, ProviderCategory category) {
    final providers = _cachedProviders[category] ?? [];
    return providers.firstWhere((provider) => provider.id == id);
  }

  // Helper methods for compatibility
  Future<void> initializeMerchants() => initialize(ProviderCategory.loyalty);
  Future<void> initializeCarriers() => initialize(ProviderCategory.sim);

  List<Provider> getAllMerchants() => getAllProviders(ProviderCategory.loyalty);
  List<Provider> getAllCarriers() => getAllProviders(ProviderCategory.sim);

  Provider getMerchantById(String id) => getProviderById(id, ProviderCategory.loyalty);
  Provider getCarrierById(String id) => getProviderById(id, ProviderCategory.sim);

  bool get isMerchantsInitialized => isInitialized(ProviderCategory.loyalty);
  bool get isCarriersInitialized => isInitialized(ProviderCategory.sim);
}