import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cartan/src/repositories/loyalty_card_repository.dart';
import 'package:cartan/src/repositories/merchants_repository.dart';
import 'package:cartan/src/models/loyalty_card.dart';

part 'cards_event.dart';
part 'cards_state.dart';

class CardsBloc extends Bloc<CardsEvent, CardsState> {
  final LoyaltyCardRepository _cardRepo;
  final MerchantsRepository _merchantsRepo;

  CardsBloc({
    required LoyaltyCardRepository cardRepo,
    required MerchantsRepository merchantsRepo,
  })  : _cardRepo = cardRepo,
        _merchantsRepo = merchantsRepo,
        super(const CardsState()) {
    on<LoadCards>(_onLoadCards);
    on<AddCard>(_onAddCard);
    on<DeleteCard>(_onDeleteCard);
  }

  Future<void> _onLoadCards(
      LoadCards event,
      Emitter<CardsState> emit,
      ) async {

    try {
      if (!_merchantsRepo.isInitialized) {
        await _merchantsRepo.initialize();
      }

      final cards = await _cardRepo.getAllCards();
      emit(state.copyWith(
        status: Status.success,
        cards: cards,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        error: e.toString(),
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