import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cartan/utils/app_snackbar.dart';
import 'package:cartan/utils/theme_provider.dart';
import 'package:cartan/src/widgets/font_size/font_size_subtitle.dart';
import 'package:cartan/src/widgets/language/language_subtitle.dart';
import 'font_size_screen.dart';
import 'feedback_screen.dart';
import 'language_screen.dart';
import 'package:cartan/src/services/doc_viewer_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
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
              leading: Icon(Icons.translate_outlined),
              trailing: Icon(AntIcons.rightOutlined),
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
              leading: Icon(AntIcons.fontSizeOutlined),
              trailing: Icon(AntIcons.rightOutlined),
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
            SizedBox(height: 12),
            ListTile(
              title: Text(localizations.privacy_policy),
              leading: Icon(AntIcons.fileProtectOutlined),
              onTap: () {
                DocViewerService.openPrivacyPolicy(
                  context,
                  title: localizations.privacy_policy,
                  onError: (e) {
                    bugsnag.notify(e, StackTrace.current);
                    AppSnackBar.showError(localizations.error);
                  },
                );
              },
            ),
            ListTile(
              title: Text(localizations.terms_of_service),
              leading: Icon(AntIcons.fileDoneOutlined),
              onTap: () {
                DocViewerService.openTermsOfService(
                  context,
                  title: localizations.terms_of_service,
                  onError: (e) {
                    bugsnag.notify(e, StackTrace.current);
                    AppSnackBar.showError(localizations.error);
                  },
                );
              },
            ),
            ListTile(
              title: Text(localizations.feedback),
              leading: Icon(AntIcons.likeOutlined),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedbackScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}