import 'dart:convert';
import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cartan/src/models/card_model.dart';
import 'providers_repository.dart';

class CardsRepository {
  final ProvidersRepository _providersRepo;
  final String _storageKey = 'user_cards';

  // Mapping object for category conversion
  static const Map<String, ProviderCategory> _categoryMapping = {
    'loyalty': ProviderCategory.loyalty,
    'sim': ProviderCategory.sim,
    'business': ProviderCategory.business,
    'membership': ProviderCategory.membership,
    'rewards': ProviderCategory.rewards,
    'informative': ProviderCategory.informative,
    'other': ProviderCategory.other,
  };

  CardsRepository(this._providersRepo);

  Future<List<CardModel>> getAllCards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cardsJson = prefs.getString(_storageKey);

    if (cardsJson == null) {
      return [];
    }

    final List<dynamic> decoded = json.decode(cardsJson);
    final cards = <CardModel>[];

    for (var item in decoded) {
      try {
        // Provider category using mapping object
        final providerCategoryString = item['providerCategory'] as String;
        final category = _categoryMapping[providerCategoryString.toLowerCase()]
            ?? ProviderCategory.loyalty; // default fallback

        // Ensure repository initialized for this category
        if (!_providersRepo.isInitialized(category)) {
          await _providersRepo.initialize(category);
        }

        final provider = _providersRepo.getProviderById(item['providerId'], category);
        cards.add(CardModel.fromJson(item, provider: provider));
      } catch (e) {
        // Log error and continue with next card
        bugsnag.notify(e, StackTrace.current);
        continue;
      }
    }

    return cards;
  }

  Future<void> addCard(CardModel card) async {
    await saveCard(card);
  }

  Future<void> saveCard(CardModel card) async {
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

  Future<void> _saveCards(List<CardModel> cards) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(cards.map((card) => card.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }
}