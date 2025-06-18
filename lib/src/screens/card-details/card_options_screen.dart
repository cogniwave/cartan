import 'package:cartan/src/models/provider_model.dart';
import 'package:cartan/src/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cartan/utils/app_snackbar.dart';
import 'package:cartan/utils/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cartan/src/models/card_model.dart';
import 'package:cartan/src/blocs/cards/cards_bloc.dart';

class CardOptionsScreen extends StatelessWidget {
  final CardModel card;

  const CardOptionsScreen({
    super.key,
    required this.card,
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
                  context.read<CardsBloc>().add(DeleteCard(cardId));

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
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.primary),
        title: Row(
          children: [
            SvgPicture.asset(
              card.provider.assetImagePath,
              width: 70,
              height: 40,
            ),
            const SizedBox(width: 8),
            Text(card.provider.displayName),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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

              if (card.provider.isSimProvider) ...[
                _buildSimCardDetails(context, theme, localizations),
                const SizedBox(height: 16),
              ],

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
                  card.provider.displayName,
                  urlType: 'map',
                ),
              ),
              ListTile(
                title: Text(localizations.website),
                leading: const Icon(AntIcons.globalOutlined),
                onTap: () => UrlLauncher.launchExternalUrl(
                  context,
                  card.provider.website,
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
    );
  }

  Widget _buildSimCardDetails(BuildContext context, ThemeData theme, AppLocalizations localizations) {
    if (card is! SimCard) return const SizedBox.shrink();

    final simCard = card as SimCard;
    final List<Widget> details = [];

    if (simCard.phoneNumber != null) {
      details.add(_buildDetailRow(localizations.phone_number, simCard.phoneNumber!, theme));
    }
    if (simCard.pin != null) {
      details.add(_buildDetailRow(localizations.pin_label, simCard.pin!, theme));
    }
    if (simCard.puk != null) {
      details.add(_buildDetailRow(localizations.puk_label, simCard.puk!, theme));
    }

    if (details.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.sim_card_details,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        ...details,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}