import 'package:cartan/src/models/merchant.dart';

/// States for MerchantsBloc

abstract class MerchantsState {}

/// Bloc is loading the merchants list
class MerchantsLoading extends MerchantsState {}

/// Bloc has loaded the list successfully
class MerchantsLoaded extends MerchantsState {
  final List<Merchant> merchants;
  MerchantsLoaded(this.merchants);
}

/// Bloc encountered an error
class MerchantsError extends MerchantsState {
  final String message;
  MerchantsError(this.message);
}