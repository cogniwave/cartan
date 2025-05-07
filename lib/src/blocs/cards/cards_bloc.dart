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
      await _cardRepo.saveCard(event.card);
      add(LoadCards());
    });
  }
}
