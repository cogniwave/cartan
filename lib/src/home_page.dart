import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/src/blocs/cards/cards_bloc.dart';
import 'package:cartan/src/blocs/cards/cards_event.dart';
import 'package:cartan/src/blocs/cards/cards_state.dart';
import 'package:cartan/src/models/loyalty_card.dart';
import 'package:cartan/src/screens/add_card/select_merchant_screen.dart';
import 'package:cartan/src/screens/card-details/card_details_screen.dart';
import 'package:cartan/src/screens/settings_screen.dart';
import 'package:cartan/src/widgets/common/add_card_button.dart';
import 'package:cartan/src/widgets/cards/cards_list_view.dart';
import 'package:cartan/src/widgets/cards/empty_cards_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// Navigate to merchant selection, then reload cards if added.
  Future<void> _onAddNewCard(BuildContext context) async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const SelectMerchantScreen()),
    );
    // Check that widget is still in the tree before using context
    if (!context.mounted) return;
    if (added == true) {
      context.read<CardsBloc>().add(LoadCards());
    }
  }

  /// Navigate to card details, then reload cards if updated.
  Future<void> _onCardTap(BuildContext context, LoyaltyCard card) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CardDetailsScreen(card: card, merchant: card.merchant),
      ),
    );
    if (!context.mounted) return;
    if (updated == true) {
      context.read<CardsBloc>().add(LoadCards());
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final addCardButton = AddCardButton(
      onPressed: () => _onAddNewCard(context),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          local.cards,
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: theme.colorScheme.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<CardsBloc>().add(LoadCards());
        },
        child: BlocBuilder<CardsBloc, CardsState>(
          builder: (context, state) {
            if (state is CardsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CardsError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is CardsLoaded) {
              final cards = state.cards;
              if (cards.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    EmptyCardsView(addCardButton: addCardButton),
                  ],
                );
              }
              return Stack(
                children: [
                  CardsListView(
                    cards: cards,
                    onCardTap: (card) => _onCardTap(context, card),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: addCardButton,
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}