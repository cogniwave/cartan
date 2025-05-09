import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cartan/utils/theme_provider.dart';
import 'package:cartan/utils/url_launcher.dart';
import 'package:cartan/src/widgets/font_size/font_size_subtitle.dart';
import 'package:cartan/src/widgets/language/language_subtitle.dart';
import 'package:cartan/src/widgets/common/url_launcher_listener.dart';
import 'package:cartan/src/blocs/url_launcher/url_launcher_bloc.dart';
import 'font_size_screen.dart';
import 'language_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return BlocProvider(
      create: (context) => UrlLauncherBloc(),
      child: UrlLauncherListener(
        child: Scaffold(
          appBar: AppBar(
            title: Text(localizations.settings),
            leading: IconButton(
              icon: const Icon(AntIcons.leftOutlined),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                ListTile(
                  title: Text(localizations.language),
                  subtitle: const LanguageSubtitle(),
                  leading: const Icon(Icons.translate_outlined),
                  trailing: const Icon(AntIcons.rightOutlined),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LanguageScreen()),
                    );
                  },
                ),
                SwitchListTile(
                  title: Text(localizations.dark_mode),
                  // subtitle: Text(localizations.theme_description),
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                  },
                  secondary: Icon(
                      themeProvider.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode
                  ),
                ),
                ListTile(
                  title: Text(localizations.font_size),
                  subtitle: const FontSizeSubtitle(),
                  leading: const Icon(AntIcons.fontSizeOutlined),
                  trailing: const Icon(AntIcons.rightOutlined),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FontSizeScreen()),
                    );
                  },
                ),
                Divider(
                  color: theme.dividerTheme.color,
                  thickness: theme.dividerTheme.thickness,
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: Text(localizations.privacy_policy),
                  leading: const Icon(AntIcons.fileProtectOutlined),
                  onTap: () {
                    UrlLauncher.launchExternalUrl(
                      context,
                      "https://www.google.pt",
                      urlType: 'web',
                    );
                  },
                ),
                ListTile(
                  title: Text(localizations.terms_of_service),
                  leading: const Icon(AntIcons.fileDoneOutlined),
                  onTap: () {
                    UrlLauncher.launchExternalUrl(
                      context,
                      "https://www.google.pt",
                      urlType: 'web',
                    );
                  },
                ),
                ListTile(
                  title: Text(localizations.feedback),
                  leading: const Icon(AntIcons.likeOutlined),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}