import 'package:cartan/src/models/loyalty_card.dart';

abstract class CardsEvent {}

// Load all cards
class LoadCards extends CardsEvent {}

// Add new card
class AddCard extends CardsEvent {
  final LoyaltyCard card;
  AddCard(this.card);
}
