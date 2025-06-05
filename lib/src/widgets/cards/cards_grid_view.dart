import 'package:flutter/material.dart';
import 'package:cartan/src/models/card_model.dart';
import 'package:cartan/src/widgets/cards/card_item.dart';

class CardsGridView extends StatelessWidget {
  final List<CardModel> cards;
  final Function(CardModel) onCardTap;

  const CardsGridView({
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
              return CardItem(
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