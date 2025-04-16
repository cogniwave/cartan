import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cartan/src/models/loyalty_card.dart';
import 'merchants_repository.dart';

class LoyaltyCardRepository {
  final MerchantsRepository _merchantsRepo;
  final String _storageKey = 'loyalty_cards';

  LoyaltyCardRepository(this._merchantsRepo);

  Future<List<LoyaltyCard>> getAllCards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cardsJson = prefs.getString(_storageKey);

    if (cardsJson == null) {
      return [];
    }

    final List<dynamic> decoded = json.decode(cardsJson);
    final cards = <LoyaltyCard>[];

    for (var item in decoded) {
      final merchant = _merchantsRepo.getMerchantById(item['merchantId']);
      if (merchant != null) {
        cards.add(LoyaltyCard.fromJson(item, merchant));
      }
    }

    return cards;
  }

  Future<void> saveCard(LoyaltyCard card) async {
    final cards = await getAllCards();
    final existingIndex = cards.indexWhere((c) => c.id == card.id);

    if (existingIndex >= 0) {
      cards[existingIndex] = card;
    } else {
      cards.add(card);
    }

    await _saveCards(cards);
  }

  Future<void> deleteCard(String id) async {
    final cards = await getAllCards();
    cards.removeWhere((card) => card.id == id);
    await _saveCards(cards);
  }

  Future<void> _saveCards(List<LoyaltyCard> cards) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(cards.map((card) => card.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }
}
