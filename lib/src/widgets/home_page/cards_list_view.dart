import 'package:flutter/material.dart';
import 'package:cartan/src/models/loyalty_card.dart';
import 'package:cartan/src/widgets/home_page/loyalty_card_item.dart';

class CardsListView extends StatelessWidget {
  final List<LoyaltyCard> cards;
  final Function(LoyaltyCard) onCardTap;

  const CardsListView({
    super.key,
    required this.cards,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Divider(
          color: theme.dividerTheme.color,
          thickness: theme.dividerTheme.thickness,
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return LoyaltyCardItem(
                card: card,
                onTap: () => onCardTap(card),
              );
            },
          ),
        ),
      ],
    );
  }
}