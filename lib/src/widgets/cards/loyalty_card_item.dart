import 'package:flutter/material.dart';
import 'package:cartan/src/models/loyalty_card.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoyaltyCardItem extends StatelessWidget {
  final LoyaltyCard card;
  final VoidCallback? onTap;

  const LoyaltyCardItem({
    super.key,
    required this.card,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12), // para efeito ripple arredondado
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SvgPicture.asset(
            card.merchant.assetImagePath,
            width: double.infinity,
            height: 200,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}