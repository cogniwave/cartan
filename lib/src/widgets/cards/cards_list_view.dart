import 'package:flutter/material.dart';
import 'package:cartan/src/models/loyalty_card.dart';
import 'package:cartan/src/widgets/cards/loyalty_card_item.dart';

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
          child: GridView.builder(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 80,
              top: 16,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
            ),
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