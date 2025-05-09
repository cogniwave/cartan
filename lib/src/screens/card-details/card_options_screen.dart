import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cartan/utils/app_snackbar.dart';
import 'package:cartan/utils/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cartan/src/models/merchant.dart';
import 'package:cartan/src/models/loyalty_card.dart';
import 'package:cartan/src/widgets/common/url_launcher_listener.dart';
import 'package:cartan/src/blocs/url_launcher/url_launcher_bloc.dart';
import 'package:cartan/src/blocs/cards/cards_bloc.dart';
import 'package:cartan/src/blocs/cards/cards_event.dart';
import 'package:cartan/src/blocs/cards/cards_state.dart';

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
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(localizations.confirm_delete),
          content: Text(localizations.confirm_delete_message),
          actions: <Widget>[
            TextButton(
              child: Text(localizations.cancel),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(dialogContext).colorScheme.error,
              ),
              onPressed: () {
                context.read<CardsBloc>().add(DeleteCard(cardId));
                Navigator.of(dialogContext).pop();
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

    return BlocProvider(
      create: (context) => UrlLauncherBloc(),
      child: BlocListener<CardsBloc, CardsState>(
        listener: (context, state) {
          if (state is CardDeletedSuccessfully) {
            if (state.cardId == card.id) {
              AppSnackBar.showSuccess(context, localizations.card_deleted_successfully);
              Navigator.pop(context, true);
            }
          } else if (state is CardsError) {
            AppSnackBar.showError(context, localizations.error_deleting_card);
          }

        },
        child: UrlLauncherListener(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(140),
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
                        child: Image.asset(
                          merchant.assetImagePath,
                          width: 100,
                          height: 100,
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

                  const SizedBox(height: 12),
                  ListTile(
                    title: Text(localizations.nearest_places),
                    leading: const Icon(AntIcons.environmentOutlined),
                    onTap: () => UrlLauncher.launchExternalUrl(
                      context,
                      merchant.displayName,
                      urlType: 'map',
                    ),
                  ),
                  ListTile(
                    title: Text(localizations.website),
                    leading: const Icon(AntIcons.globalOutlined),
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
                    leading: const Icon(AntIcons.deleteOutlined),
                    iconColor: theme.colorScheme.error,
                    onTap: () {
                      _showDeleteDialog(context, card.id);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}