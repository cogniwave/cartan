import 'package:flutter/material.dart';
import 'package:cartan/src/models/card_model.dart';
import 'package:cartan/src/widgets/cards/card_item.dart';

class CardsListView extends StatelessWidget {
  final List<CardModel> cards;
  final Function(CardModel) onCardTap;

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
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 80,
              top: 16,
            ),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CardItem(
                  card: card,
                  onTap: () => onCardTap(card),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}