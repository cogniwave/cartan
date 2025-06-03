import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cartan/src/models/provider_model.dart';

enum ProviderCategory {
  loyalty,
  sim,
  membership,
  rewards,
  informative,
  business,
  other
}

extension ProviderCategoryExtension on ProviderCategory {
  String get name {
    switch (this) {
      case ProviderCategory.loyalty:
        return 'Loyalty';
      case ProviderCategory.sim:
        return 'Sim';
      case ProviderCategory.membership:
        return 'Membership';
      case ProviderCategory.rewards:
        return 'Rewards';
      case ProviderCategory.informative:
        return 'Informative';
      case ProviderCategory.business:
        return 'Business';
      case ProviderCategory.other:
        return 'Other';
    }
  }

  String get fileName {
    switch (this) {
      case ProviderCategory.loyalty:
        return 'lib/assets/data/merchants.json';
      case ProviderCategory.sim:
        return 'lib/assets/data/sim_carriers.json';
      case ProviderCategory.membership:
        return 'lib/assets/data/membership_providers.json';
      case ProviderCategory.rewards:
        return 'lib/assets/data/rewards_providers.json';
      case ProviderCategory.informative:
        return 'lib/assets/data/informative_providers.json';
      case ProviderCategory.business:
        return 'lib/assets/data/business_providers.json';
      case ProviderCategory.other:
        return 'lib/assets/data/other_providers.json';
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

  // Helper methods for compatibility (legacy methods)
  Future<void> initializeMerchants() => initialize(ProviderCategory.loyalty);
  Future<void> initializeCarriers() => initialize(ProviderCategory.sim);
  Future<void> initializeMembership() => initialize(ProviderCategory.membership);
  Future<void> initializeRewards() => initialize(ProviderCategory.rewards);
  Future<void> initializeInformative() => initialize(ProviderCategory.informative);
  Future<void> initializeBusiness() => initialize(ProviderCategory.business);
  Future<void> initializeOther() => initialize(ProviderCategory.other);

  List<Provider> getAllMerchants() => getAllProviders(ProviderCategory.loyalty);
  List<Provider> getAllCarriers() => getAllProviders(ProviderCategory.sim);
  List<Provider> getAllMembership() => getAllProviders(ProviderCategory.membership);
  List<Provider> getAllRewards() => getAllProviders(ProviderCategory.rewards);
  List<Provider> getAllInformative() => getAllProviders(ProviderCategory.informative);
  List<Provider> getAllBusiness() => getAllProviders(ProviderCategory.business);
  List<Provider> getAllOther() => getAllProviders(ProviderCategory.other);

  Provider getMerchantById(String id) => getProviderById(id, ProviderCategory.loyalty);
  Provider getCarrierById(String id) => getProviderById(id, ProviderCategory.sim);
  Provider getMembershipById(String id) => getProviderById(id, ProviderCategory.membership);
  Provider getRewardsById(String id) => getProviderById(id, ProviderCategory.rewards);
  Provider getInformativeById(String id) => getProviderById(id, ProviderCategory.informative);
  Provider getBusinessById(String id) => getProviderById(id, ProviderCategory.business);
  Provider getOtherById(String id) => getProviderById(id, ProviderCategory.other);

  bool get isMerchantsInitialized => isInitialized(ProviderCategory.loyalty);
  bool get isCarriersInitialized => isInitialized(ProviderCategory.sim);
  bool get isMembershipInitialized => isInitialized(ProviderCategory.membership);
  bool get isRewardsInitialized => isInitialized(ProviderCategory.rewards);
  bool get isInformativeInitialized => isInitialized(ProviderCategory.informative);
  bool get isBusinessInitialized => isInitialized(ProviderCategory.business);
  bool get isOtherInitialized => isInitialized(ProviderCategory.other);
}