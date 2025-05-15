import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/src/blocs/cards/cards_bloc.dart';
import 'package:cartan/src/models/loyalty_card.dart';
import 'package:cartan/src/screens/add_card/select_merchant_screen.dart';
import 'package:cartan/src/screens/card-details/card_details_screen.dart';
import 'package:cartan/src/screens/settings_screen.dart';
import 'package:cartan/src/widgets/common/add_card_button.dart';
import 'package:cartan/src/widgets/cards/cards_list_view.dart';
import 'package:cartan/src/widgets/cards/empty_cards_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Navigate to merchant selection, then reload cards if added.
  Future<void> _onAddNewCard(BuildContext context) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const SelectMerchantScreen()),
    );
  }

  // Navigate to card details, then reload cards if updated.
  Future<void> _onCardTap(BuildContext context, LoyaltyCard card) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CardDetailsScreen(card: card, merchant: card.merchant),
      ),
    ).then((result) {
      if (result == true && context.mounted) {
        context.read<CardsBloc>().add(const LoadCards());
      }
    });
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
          context.read<CardsBloc>().add(const LoadCards());
        },
        child: BlocBuilder<CardsBloc, CardsState>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == Status.failure) {
              return Center(child: Text('Error: ${state.error}'));
            } else if (state.status == Status.success) {
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
            // Unknown state, should not occur
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}