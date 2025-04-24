import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/utils/app_snackbar.dart';

class UrlLauncher {

  static Future<void> launchExternalUrl(
      BuildContext context,
      String target, {
        required String urlType,
      }) async {
    final localizations = AppLocalizations.of(context)!;
    Uri url;

    if (urlType == 'map') {
      final String encodedQuery = Uri.encodeComponent(target);
      if (Platform.isIOS) {
        // Apple Maps
        url = Uri.parse("https://maps.apple.com/?q=$encodedQuery");
      } else {
        // Google Maps (Android)
        url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$encodedQuery");
      }
    } else if (urlType == 'web') {
      url = Uri.parse(target);
    } else {
      throw ArgumentError('Invalid URL type: $urlType. Supported types are "map" and "web".');
    }

    try {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        AppSnackBar.showError(context, localizations.error);
      }
    } catch (e) {
      bugsnag.notify(e, StackTrace.current);
      AppSnackBar.showError(context, localizations.error);
    }
  }
}