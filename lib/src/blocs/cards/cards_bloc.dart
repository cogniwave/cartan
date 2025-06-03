import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cartan/src/repositories/cards_repository.dart';
import 'package:cartan/src/models/card_model.dart';

part 'cards_event.dart';
part 'cards_state.dart';

class CardsBloc extends Bloc<CardsEvent, CardsState> {
  final CardsRepository _cardRepo;

  CardsBloc({
    required CardsRepository cardRepo,
  })  : _cardRepo = cardRepo,
        super(const CardsState()) {
    on<LoadCards>(_onLoadCards);
    on<AddCard>(_onAddCard);
    on<DeleteCard>(_onDeleteCard);
  }

  Future<void> _onLoadCards(
      LoadCards event,
      Emitter<CardsState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final cards = await _cardRepo.getAllCards();
      emit(state.copyWith(
        status: Status.success,
        cards: cards,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: Status.failure,
        error: error.toString(),
      ));
    }
  }

  Future<void> _onAddCard(
      AddCard event,
      Emitter<CardsState> emit,
      ) async {
    try {
      emit(state.copyWith(
        status: Status.loading,
      ));

      await _cardRepo.addCard(event.card);

      final updatedCards = await _cardRepo.getAllCards();

      emit(state.copyWith(
        status: Status.success,
        cards: updatedCards,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteCard(
      DeleteCard event,
      Emitter<CardsState> emit,
      ) async {
    try {
      emit(state.copyWith(
        status: Status.loading,
      ));

      await _cardRepo.deleteCard(event.cardId);

      final updatedCards = await _cardRepo.getAllCards();

      emit(state.copyWith(
        status: Status.success,
        cards: updatedCards,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        error: e.toString(),
      ));
    }
  }
}