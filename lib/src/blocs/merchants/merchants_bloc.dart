import 'package:bloc/bloc.dart';
import 'package:cartan/src/repositories/merchants_repository.dart';
import 'merchants_event.dart';
import 'merchants_state.dart';

/// BLoC to manage loading & reloading of merchants list
class MerchantsBloc extends Bloc<MerchantsEvent, MerchantsState> {
  final MerchantsRepository _repo;

  MerchantsBloc(this._repo) : super(MerchantsLoading()) {
    on<LoadMerchants>((event, emit) async {
      emit(MerchantsLoading());
      try {
        if (!_repo.isInitialized) {
          await _repo.initialize();
        }
        final merchants = _repo.getAllMerchants();
        emit(MerchantsLoaded(merchants));
      } catch (e) {
        emit(MerchantsError(e.toString()));
      }
    });
  }
}