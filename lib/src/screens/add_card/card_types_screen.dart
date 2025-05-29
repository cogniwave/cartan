import 'package:flutter/material.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardTypeScreen extends StatelessWidget {
  const CardTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.card_type),
        backgroundColor: theme.dividerTheme.color,
      ),
      body: Container(
        color: theme.colorScheme.surface,
        padding: const EdgeInsets.all(48.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 24.0,
          mainAxisSpacing: 24.0,
          childAspectRatio: 1.0,
          children: [
            _buildCardTypeItem(
              context,
              icon: AntIcons.giftOutlined,
              title: 'Pontos',
              onTap: () {
                // TODO: Navigate to points card creation screen
              },
            ),
            _buildCardTypeItem(
              context,
              icon: AntIcons.mobileOutlined,
              title: 'SIM Card',
              onTap: () {
                // TODO: Navigate to SIM card creation screen
              },
            ),
            _buildCardTypeItem(
              context,
              icon: AntIcons.contactsOutlined,
              title: 'Visita',
              onTap: () {
                // TODO: Navigate to business card creation screen
              },
            ),
            _buildCardTypeItem(
              context,
              icon: AntIcons.crownOutlined,
              title: 'Membership',
              onTap: () {
                // TODO: Navigate to membership card creation screen
              },
            ),
            _buildCardTypeItem(
              context,
              icon: AntIcons.infoCircleOutlined,
              title: 'Informativos',
              onTap: () {
                // TODO: Navigate to information card creation screen
              },
            ),
            _buildCardTypeItem(
              context,
              icon: AntIcons.trophyOutlined,
              title: 'Recompensas',
              onTap: () {
                // TODO: Navigate to rewards card creation screen
              },
            ),
            _buildCardTypeItem(
              context,
              icon: AntIcons.appstoreOutlined,
              title: 'Outros',
              onTap: () {
                // TODO: Navigate to other card types screen
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTypeItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.secondary,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60.0,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}