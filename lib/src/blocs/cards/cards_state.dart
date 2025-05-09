import 'package:cartan/src/models/loyalty_card.dart';

abstract class CardsState {}

class CardsLoading extends CardsState {}

// Success
class CardsLoaded extends CardsState {
  final List<LoyaltyCard> cards;
  CardsLoaded(this.cards);
}

// Error
class CardsError extends CardsState {
  final String message;
  CardsError(this.message);
}

class CardDeletedSuccessfully extends CardsState {
  final String cardId;
  CardDeletedSuccessfully(this.cardId);
}
