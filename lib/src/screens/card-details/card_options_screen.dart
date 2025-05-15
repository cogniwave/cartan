import 'package:cartan/src/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cartan/utils/app_snackbar.dart';
import 'package:cartan/utils/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:cartan/src/models/merchant.dart';
import 'package:cartan/src/models/loyalty_card.dart';
import 'package:cartan/src/repositories/loyalty_card_repository.dart';

class CardOptionsScreen extends StatelessWidget {
  final LoyaltyCard card;
  final Merchant merchant;

  const CardOptionsScreen({
    super.key,
    required this.card,
    required this.merchant,
  });

  void _showDeleteDialog(BuildContext context, String cardId) {
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.confirm_delete),
          content: Text(localizations.confirm_delete_message),
          actions: <Widget>[
            TextButton(
              child: Text(localizations.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () async {
                try {
                  final repository = Provider.of<LoyaltyCardRepository>(context, listen: false);

                  await repository.deleteCard(cardId);

                  NavigationService().pop();
                  AppSnackBar.showSuccess(localizations.card_deleted_successfully);

                  NavigationService().pop(true);
                } catch (e) {
                  NavigationService().pop();
                  AppSnackBar.showError(localizations.error_deleting_card);
                }
              },
              child: Text(localizations.confirm),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    String formatMemberId(String id) {
      return id
          .replaceAllMapped(RegExp(r'.{1,3}'), (match) => '${match.group(0)} ')
          .trim();
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: SafeArea(
          child: Container(
            color: theme.colorScheme.surface,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(AntIcons.leftOutlined, color: theme.colorScheme.primary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),

                Positioned(
                  left: 56,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Text(
                      merchant.displayName,
                      style: TextStyle(color: theme.colorScheme.primary, fontSize: 22),
                    ),
                  ),
                ),

                Positioned(
                  right: 82,
                  top: 44,
                  child: SvgPicture.asset(
                    merchant.assetImagePath,
                    width: 100,
                    height: 70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              localizations.card_number,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                formatMemberId(card.memberId),
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            Divider(
              color: theme.dividerTheme.color,
              thickness: theme.dividerTheme.thickness,
            ),

            SizedBox(height: 12),
            ListTile(
              title: Text(localizations.nearest_places),
              leading: Icon(AntIcons.environmentOutlined),
              onTap: () => UrlLauncher.launchExternalUrl(
                context,
                merchant.displayName,
                urlType: 'map',
              ),
            ),
            ListTile(
              title: Text(localizations.website),
              leading: Icon(AntIcons.globalOutlined),
              onTap: () => UrlLauncher.launchExternalUrl(
                context,
                merchant.website,
                urlType: 'web',
              ),
            ),
            Divider(
              color: theme.dividerTheme.color,
              thickness: theme.dividerTheme.thickness,
            ),
            ListTile(
              title: Text(localizations.remove),
              textColor: theme.colorScheme.error,
              leading: Icon(AntIcons.deleteOutlined),
              iconColor: theme.colorScheme.error,
              onTap: () {
                _showDeleteDialog(context, card.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}