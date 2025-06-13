import 'package:cartan/utils/custom_tap.dart';
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
import 'package:cartan/src/services/web_view_service.dart';

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
        leading: IconButton(icon: const Icon(AntIcons.leftOutlined), onPressed: () => Navigator.of(context).pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // Language
            CustomTap(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LanguageScreen()));
              },
              child: ListTile(
                title: Text(localizations.language),
                subtitle: const LanguageSubtitle(),
                leading: const Icon(Icons.translate_outlined),
                trailing: const Icon(AntIcons.rightOutlined),
              ),
            ),

            // Dark mode switch
            SwitchListTile(
              title: Text(localizations.dark_mode),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              },
              secondary: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            ),

            // Font size
            CustomTap(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FontSizeScreen()));
              },
              child: ListTile(
                title: Text(localizations.font_size),
                subtitle: const FontSizeSubtitle(),
                leading: const Icon(AntIcons.fontSizeOutlined),
                trailing: Icon(AntIcons.rightOutlined),
              ),
            ),

            Divider(color: theme.dividerTheme.color, thickness: theme.dividerTheme.thickness),
            const SizedBox(height: 12),

            // Privacy Policy
            CustomTap(
              onTap: () {
                WebViewService.openPrivacyPolicy(
                  context,
                  title: localizations.privacy_policy,
                  onError: (e) {
                    bugsnag.notify(e, StackTrace.current);
                    AppSnackBar.showError(localizations.error);
                  },
                );
              },
              child: ListTile(
                title: Text(localizations.privacy_policy),
                leading: const Icon(AntIcons.fileProtectOutlined),
              ),
            ),

            // Terms of Service
            CustomTap(
              onTap: () {
                WebViewService.openTermsAndConditions(
                  context,
                  title: localizations.terms_and_conditions,
                  onError: (e) {
                    bugsnag.notify(e, StackTrace.current);
                    AppSnackBar.showError(localizations.error);
                  },
                );
              },
              child: ListTile(
                title: Text(localizations.terms_and_conditions),
                leading: const Icon(AntIcons.fileDoneOutlined),
              ),
            ),

            // Feedback
            CustomTap(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackScreen()));
              },
              child: ListTile(title: Text(localizations.feedback), leading: const Icon(AntIcons.likeOutlined)),
            ),
          ],
        ),
      ),
    );
  }
}
