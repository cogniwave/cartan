import 'package:cartan/src/models/merchant.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class MerchantsRepository {
  List<Merchant> _merchants = [];

  Future<void> initialize() async {
    if (_merchants.isNotEmpty) {
      return; // Já inicializado
    }

    // Load from JSON
    final jsonString = await rootBundle.loadString('lib/assets/data/merchants.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    _merchants = jsonList.map((json) => Merchant.fromJson(json)).toList();
  }

  bool get isInitialized => _merchants.isNotEmpty;

  List<Merchant> getAllMerchants() {
    return _merchants;
  }

  Merchant getMerchantById(String id) {
    return _merchants.firstWhere((merchant) => merchant.id == id);
  }
}