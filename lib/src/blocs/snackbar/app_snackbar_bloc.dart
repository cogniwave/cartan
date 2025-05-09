import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/src/themes/app_themes.dart';

abstract class SnackBarEvent {}

class ShowSuccessEvent extends SnackBarEvent {
  final String message;

  ShowSuccessEvent(this.message);
}

class ShowErrorEvent extends SnackBarEvent {
  final String message;

  ShowErrorEvent(this.message);
}

class SnackBarState {}

class SnackBarBloc extends Bloc<SnackBarEvent, SnackBarState> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  SnackBarBloc(this.scaffoldMessengerKey) : super(SnackBarState()) {
    on<ShowSuccessEvent>(_onShowSuccess);
    on<ShowErrorEvent>(_onShowError);
  }

  void _onShowSuccess(ShowSuccessEvent event, Emitter<SnackBarState> emit) {
    _showMessage(
      message: event.message,
      isError: false,
    );
  }

  void _onShowError(ShowErrorEvent event, Emitter<SnackBarState> emit) {
    _showMessage(
      message: event.message,
      isError: true,
      duration: const Duration(seconds: 4),
    );
  }

  void _showMessage({
    required String message,
    required bool isError,
    Duration duration = const Duration(seconds: 3),
  }) {
    final context = scaffoldMessengerKey.currentContext;
    if (context == null) return;

    final Color color = isError
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).extension<CustomColors>()!.success;

    final IconData icon = isError
        ? AntIcons.closeOutlined
        : AntIcons.checkOutlined;

    final String actionLabel = isError
        ? AppLocalizations.of(context)!.close
        : 'OK';

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: color),
            ),
          ),
        ],
      ),
      backgroundColor: color.withValues(alpha: 0.4),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(16),
      duration: duration,
      action: SnackBarAction(
        label: actionLabel,
        textColor: color,
        onPressed: () {
          scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
        },
      ),
    );

    scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}