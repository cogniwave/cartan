import 'package:cartan/src/models/merchant.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class MerchantsRepository {
  List<Merchant> _merchants = [];
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    // Load from JSON
    final jsonString = await rootBundle.loadString('lib/assets/data/merchants.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    _merchants = jsonList.map((json) => Merchant.fromJson(json)).toList();
    _initialized = true;
  }

  bool get isInitialized => _initialized;

  List<Merchant> getAllMerchants() {
    return _merchants;
  }

  Merchant? getMerchantById(String id) {
    try {
      return _merchants.firstWhere((merchant) => merchant.id == id);
    } catch (e) {
      return null;
    }
  }
}