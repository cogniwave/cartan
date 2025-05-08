import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'url_launcher_event.dart';
import 'url_launcher_state.dart';

class UrlLauncherBloc extends Bloc<UrlLauncherEvent, UrlLauncherState> {
  UrlLauncherBloc() : super(UrlLauncherInitial()) {
    on<LaunchWebUrlEvent>(_onLaunchWebUrl);
    on<LaunchMapEvent>(_onLaunchMap);
  }

  Future<void> _onLaunchWebUrl(
    LaunchWebUrlEvent event,
    Emitter<UrlLauncherState> emit,
  ) async {
    emit(UrlLaunchLoading());

    try {
      final uri = Uri.parse(event.url);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (launched) {
        emit(UrlLaunchSuccess());
      } else {
        emit(const UrlLaunchFailure('error'));
      }
    } catch (e, stack) {
      bugsnag.notify(e, stack);
      emit(const UrlLaunchFailure('error'));
    }
  }

  Future<void> _onLaunchMap(
    LaunchMapEvent event,
    Emitter<UrlLauncherState> emit,
  ) async {
    emit(UrlLaunchLoading());

    final String encodedQuery = Uri.encodeComponent(event.searchQuery);
    Uri? mapUrl;

    if (Platform.isAndroid) {
      mapUrl = Uri.parse("geo:0,0?q=$encodedQuery");
    } else if (Platform.isIOS) {
      mapUrl = Uri.parse("maps://?q=$encodedQuery");
    }

    if (mapUrl != null) {
      try {
        final bool launched = await launchUrl(
          mapUrl,
          mode: LaunchMode.externalApplication,
        );

        if (launched) {
          emit(UrlLaunchSuccess());
        } else {
          if (Platform.isIOS) {
            final appleUrl = Uri.parse(
              "http://maps.apple.com/?q=$encodedQuery",
            );
            final appleLaunched = await launchUrl(
              appleUrl,
              mode: LaunchMode.externalApplication,
            );

            if (appleLaunched) {
              emit(UrlLaunchSuccess());
            } else {
              emit(const NoMapAppsInstalled());
            }
          } else {
            final googleUrl = Uri.parse(
              "https://www.google.com/maps/search/?api=1&query=$encodedQuery",
            );
            final googleLaunched = await launchUrl(
              googleUrl,
              mode: LaunchMode.externalApplication,
            );

            if (googleLaunched) {
              emit(UrlLaunchSuccess());
            } else {
              emit(const NoMapAppsInstalled());
            }
          }
        }
      } catch (e, stack) {
        bugsnag.notify(e, stack);
        emit(const UrlLaunchFailure('error'));
      }
    } else {
      emit(const UrlLaunchFailure('error'));
    }
  }
}