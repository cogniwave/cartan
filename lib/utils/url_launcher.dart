import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/utils/app_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  static Future<void> launchExternalUrl(
      BuildContext context,
      String target, {
        required String urlType,
      }) async {
    final localizations = AppLocalizations.of(context)!;

    try {
      if (urlType == 'map') {
        await _launchMap(context, target);
      } else {
        // urlType == 'web'
        final uri = Uri.parse(target);
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          AppSnackBar.showError(context, localizations.error);
        }
      }
    } catch (e, stack) {
      bugsnag.notify(e, stack);
      AppSnackBar.showError(context, localizations.error);
    }
  }

  // Launch map with system chooser dialog (native to Android/iOS)
  static Future<void> _launchMap(BuildContext context, String searchQuery) async {
    final localizations = AppLocalizations.of(context)!;
    final String encodedQuery = Uri.encodeComponent(searchQuery);
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

        if (!launched) {
          if (Platform.isIOS) {
            final appleUrl = Uri.parse("http://maps.apple.com/?q=$encodedQuery");
            final appleLaunched = await launchUrl(
              appleUrl,
              mode: LaunchMode.externalApplication,
            );

            if (!appleLaunched) {
              AppSnackBar.showError(context, localizations.no_map_apps_installed);
            }
          } else {
            final googleUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$encodedQuery");
            final googleLaunched = await launchUrl(
              googleUrl,
              mode: LaunchMode.externalApplication,
            );

            if (!googleLaunched) {
              AppSnackBar.showError(context, localizations.no_map_apps_installed);
            }
          }
        }
      } catch (e) {
        bugsnag.notify(e, StackTrace.current);
        AppSnackBar.showError(context, localizations.error);
      }
    }
  }
}