part of 'cards_bloc.dart';

sealed class CardsEvent extends Equatable {
  const CardsEvent();

  @override
  List<Object> get props => [];
}

final class LoadCards extends CardsEvent {
  const LoadCards();
}

final class AddCard extends CardsEvent {
  final CardModel card;

  const AddCard(this.card);

  @override
  List<Object> get props => [card];
}

final class DeleteCard extends CardsEvent {
  final String cardId;

  const DeleteCard(this.cardId);

  @override
  List<Object> get props => [cardId];
}