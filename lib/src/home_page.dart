import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/src/blocs/cards/cards_bloc.dart';
import 'package:cartan/src/models/loyalty_card.dart';
import 'package:cartan/src/screens/add_card/select_merchant_screen.dart';
import 'package:cartan/src/screens/card-details/card_details_screen.dart';
import 'package:cartan/src/screens/settings_screen.dart';
import 'package:cartan/src/widgets/common/add_card_button.dart';
import 'package:cartan/src/widgets/common/searchable_app_bar.dart';
import 'package:cartan/src/widgets/cards/cards_grid_view.dart';
import 'package:cartan/src/widgets/cards/cards_list_view.dart';
import 'package:cartan/src/widgets/cards/empty_cards_view.dart';

// Define view type enum
enum CardViewType {
  grid,
  list;

  CardViewType toggle() {
    return this == CardViewType.grid ? CardViewType.list : CardViewType.grid;
  }

  IconData get icon {
    return this == CardViewType.grid
        ? Icons.view_list
        : Icons.grid_view;
  }
}

class CardViewCubit extends Cubit<CardViewType> {
  CardViewCubit() : super(CardViewType.grid);

  void toggleView() => emit(state.toggle());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';

  // Navigate to merchant selection, then reload cards if added.
  Future<void> _onAddNewCard(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const SelectMerchantScreen()),
    );

    if (result == true && context.mounted) {
      context.read<CardsBloc>().add(const LoadCards());
    }
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
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final addCardButton = AddCardButton(
      onPressed: () => _onAddNewCard(context),
    );

    return BlocProvider(
      create: (_) => CardViewCubit(),
      child: BlocBuilder<CardViewCubit, CardViewType>(
          builder: (context, viewType) {
            return Scaffold(
              appBar: SearchableAppBar(
                title: localizations.cards,
                searchHint: localizations.search,
                titleStyle: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                searchStyle: TextStyle(color: theme.colorScheme.onSurface),
                backgroundColor: theme.appBarTheme.backgroundColor,
                onSearch: (query) {
                  setState(() {
                    _searchQuery = query.toLowerCase();
                  });
                },
                trailingActions: [
                  IconButton(
                    icon: Icon(viewType.icon, color: theme.colorScheme.primary),
                    onPressed: () {
                      context.read<CardViewCubit>().toggleView();
                    },
                  ),
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

                      // Filter cards based on search query if needed
                      final filteredCards = _searchQuery.isEmpty
                          ? cards
                          : cards.where((card) =>
                      card.name.toLowerCase().contains(_searchQuery) ||
                          card.merchant.displayName.toLowerCase().contains(_searchQuery)
                      ).toList();

                      if (cards.isEmpty) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            EmptyCardsView(addCardButton: addCardButton),
                          ],
                        );
                      }

                      if (filteredCards.isEmpty && _searchQuery.isNotEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  AntIcons.warningOutlined,
                                  size: 64,
                                  color: theme.colorScheme.primary.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  localizations.no_results_found,
                                  style: theme.textTheme.headlineSmall,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Stack(
                        children: [
                          viewType == CardViewType.grid
                              ? CardsGridView(
                            cards: filteredCards,
                            onCardTap: (card) => _onCardTap(context, card),
                          )
                              : CardsListView(
                            cards: filteredCards,
                            onCardTap: (card) => _onCardTap(context, card),
                          ),
                          SafeArea(
                            minimum: const EdgeInsets.all(16),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: addCardButton,
                            ),
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
      ),
    );
  }
}