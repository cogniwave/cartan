import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cartan/src/blocs/snackbar/app_snackbar_bloc.dart';

// Classe de utilidade para facilitar o uso do SnackBarBloc
class AppSnackBar {
  // Success message
  static void showSuccess(BuildContext context, String message) {
    if (context.mounted) {
      context.read<SnackBarBloc>().add(ShowSuccessEvent(message));
    }
  }

  // Error message
  static void showError(BuildContext context, String message) {
    if (context.mounted) {
      context.read<SnackBarBloc>().add(ShowErrorEvent(message));
    }
  }
}