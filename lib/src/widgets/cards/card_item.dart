import 'package:flutter/material.dart';
import 'package:cartan/src/models/card_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardItem extends StatelessWidget {
  final CardModel card;
  final VoidCallback? onTap;

  const CardItem({
    super.key,
    required this.card,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SvgPicture.asset(
            card.provider.assetImagePath,
            width: double.infinity,
            height: 200,
            fit: BoxFit.fill,
          ),
        ),

      ),
    );
  }
}