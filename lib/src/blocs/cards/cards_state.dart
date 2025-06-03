part of 'cards_bloc.dart';

enum Status { loading, success, failure }

final class CardsState extends Equatable {
  const CardsState({
    this.status = Status.loading,
    this.cards = const <CardModel>[],
    this.error,
  });

  final Status status;
  final List<CardModel> cards;
  final String? error;

  @override
  List<Object?> get props => [status, cards, error];

  CardsState copyWith({
    Status? status,
    List<CardModel>? cards,
    String? error,
  }) {
    return CardsState(
      status: status ?? this.status,
      cards: cards ?? this.cards,
      error: error ?? this.error,
    );
  }
}