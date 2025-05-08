import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/utils/app_snackbar.dart';
import 'package:cartan/src/blocs/url_launcher/url_launcher_bloc.dart';
import 'package:cartan/src/blocs/url_launcher/url_launcher_state.dart';

class UrlLauncherListener extends StatelessWidget {
  final Widget child;

  const UrlLauncherListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UrlLauncherBloc, UrlLauncherState>(
      listener: (context, state) {
        final localizations = AppLocalizations.of(context)!;

        if (state is UrlLaunchFailure) {
          AppSnackBar.showError(context, localizations.error);
        } else if (state is NoMapAppsInstalled) {
          AppSnackBar.showError(context, localizations.no_map_apps_installed);
        }
      },
      child: child,
    );
  }
}
