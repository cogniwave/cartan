import 'package:bloc/bloc.dart';
import 'package:cartan/src/repositories/loyalty_card_repository.dart';
import 'package:cartan/src/repositories/merchants_repository.dart';
import 'cards_event.dart';
import 'cards_state.dart';

class CardsBloc extends Bloc<CardsEvent, CardsState> {
  final LoyaltyCardRepository _cardRepo;
  final MerchantsRepository _merchantsRepo;

  CardsBloc(this._cardRepo, this._merchantsRepo) : super(CardsLoading()) {
    on<LoadCards>((event, emit) async {
      emit(CardsLoading());
      try {
        // ensure merchants data is loaded
        if (!_merchantsRepo.isInitialized) {
          await _merchantsRepo.initialize();
        }
        final cards = await _cardRepo.getAllCards();
        emit(CardsLoaded(cards));
      } catch (e) {
        emit(CardsError(e.toString()));
      }
    });

    // Save the new card
    on<AddCard>((event, emit) async {
      try {
        await _cardRepo.saveCard(event.card);
        add(LoadCards());
      } catch (e) {
        emit(CardsError(e.toString()));
      }
    });

    // Delete a card
    on<DeleteCard>((event, emit) async {
      try {
        await _cardRepo.deleteCard(event.cardId);
        emit(CardDeletedSuccessfully(event.cardId));
        add(LoadCards());
      } catch (e) {
        emit(CardsError(e.toString()));
      }
    });
  }
}