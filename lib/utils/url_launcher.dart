import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cartan/src/blocs/url_launcher/url_launcher_bloc.dart';
import 'package:cartan/src/blocs/url_launcher/url_launcher_event.dart';

class UrlLauncher {
  static void launchExternalUrl(
      BuildContext context,
      String target, {
        required String urlType,
      }) {

    if (urlType == 'map') {
      context.read<UrlLauncherBloc>().add(LaunchMapEvent(target));
    } else {
      // urlType == 'web'
      context.read<UrlLauncherBloc>().add(LaunchWebUrlEvent(target));
    }
  }
}