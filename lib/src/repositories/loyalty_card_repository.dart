import 'dart:convert';
import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cartan/src/models/loyalty_card.dart';
import 'providers_repository.dart';

class LoyaltyCardRepository {
  final ProvidersRepository _providersRepo;
  final String _storageKey = 'loyalty_cards';

  LoyaltyCardRepository(this._providersRepo);

  Future<List<LoyaltyCard>> getAllCards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cardsJson = prefs.getString(_storageKey);

    if (cardsJson == null) {
      return [];
    }

    final List<dynamic> decoded = json.decode(cardsJson);
    final cards = <LoyaltyCard>[];

    for (var item in decoded) {
      try {
        // Provider category
        final providerCategory = item['providerCategory'] as String;
        final category = providerCategory.toLowerCase() == 'loyalty'
            ? ProviderCategory.loyalty
            : ProviderCategory.sim;

        // Ensure repository initialized for this category
        if (!_providersRepo.isInitialized(category)) {
          await _providersRepo.initialize(category);
        }

        final provider = _providersRepo.getProviderById(item['providerId'], category);
        cards.add(LoyaltyCard.fromJson(item, provider: provider));
      } catch (e) {
        // Log error and continue with next card
        bugsnag.notify(e, StackTrace.current);
        continue;
      }
    }

    return cards;
  }

  Future<void> addCard(LoyaltyCard card) async {
    await saveCard(card);
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