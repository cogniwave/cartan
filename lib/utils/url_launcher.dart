import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/utils/app_snackbar.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  static const _preferredMapKey = 'preferred_map_app';

  static Future<void> launchExternalUrl(
      BuildContext context,
      String target, {
        required String urlType,
      }) async {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    try {
      if (urlType == 'map') {
        final prefs = await SharedPreferences.getInstance();
        final availableMaps = await MapLauncher.installedMaps;

        if (availableMaps.isEmpty) {
          AppSnackBar.showError(context, localizations.no_map_apps_installed);
          return;
        }

        // Try to retrieve the user’s preferred map app
        AvailableMap? preferredMap;
        final preferredName = prefs.getString(_preferredMapKey);
        if (preferredName != null) {
          for (final m in availableMaps) {
            if (m.mapName == preferredName) {
              preferredMap = m;
              break;
            }
          }
        }
        if (preferredMap != null) {
          // Launch directly with preferred app
          await preferredMap.showMarker(
            coords: Coords(0, 0),
            title: target,
            extraParams: {'q': target},
          );
          return;
        }

        // If only one map app is installed, use it without asking
        if (availableMaps.length == 1) {
          final singleMap = availableMaps.first;
          await singleMap.showMarker(
            coords: Coords(0, 0),
            title: target,
            extraParams: {'q': target},
          );
          // Persist as default
          await prefs.setString(_preferredMapKey, singleMap.mapName);
          return;
        }

        // Multiple map apps available: show choice sheet with "remember" option
        showModalBottomSheet(
          context: context,
          builder: (_) {
            bool rememberChoice = false;

            return StatefulBuilder(
              builder: (context, setState) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          localizations.choose_map_app,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      CheckboxListTile(
                        title: Text(localizations.remember_choice),
                        value: rememberChoice,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (val) {
                          setState(() => rememberChoice = val ?? false);
                        },
                      ),
                      Divider(height: 1),
                      ...availableMaps.map((map) {
                        final icon = _getAntIconForMap(map.mapName);
                        return ListTile(
                          leading: Icon(icon, color: theme.colorScheme.primary),
                          title: Text(map.mapName),
                          onTap: () async {
                            Navigator.pop(context); // close sheet
                            await map.showMarker(
                              coords: Coords(0, 0),
                              title: target,
                              extraParams: {'q': target},
                            );
                            // persist choice if opted in
                            if (rememberChoice) {
                              await prefs.setString(_preferredMapKey, map.mapName);
                            }
                          },
                        );
                      }),
                    ],
                  ),
                );
              },
            );
          },
        );
      } else {
        // urlType == 'web'
        final uri = Uri.parse(target);
        final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!launched) {
          AppSnackBar.showError(context, localizations.error);
        }
      }
    } catch (e, stack) {
      bugsnag.notify(e, stack);
      AppSnackBar.showError(context, localizations.error);
    }
  }

  /// Returns an AntDesign icon corresponding to the map app name.
  static IconData _getAntIconForMap(String mapName) {
    final lower = mapName.toLowerCase();
    if (lower.contains('google')) return AntIcons.googleOutlined;
    if (lower.contains('apple')) return AntIcons.appleOutlined;
    if (lower.contains('waze')) return AntIcons.carOutlined;
    return AntIcons.environmentOutlined;
  }
}
