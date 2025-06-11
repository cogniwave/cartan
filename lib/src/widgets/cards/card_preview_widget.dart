import 'package:cartan/src/forms/card_form_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardPreviewWidget extends StatelessWidget {
  final String assetImagePath;
  final CardFormManager? formManager;

  const CardPreviewWidget({
    super.key,
    required this.assetImagePath,
    this.formManager,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 150,
              height: 100,
              child: FittedBox(
                fit: BoxFit.fill,
                child: SvgPicture.asset(assetImagePath),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (formManager?.cardTypeData.displayName != null)
            Text(
              formManager!.cardTypeData.displayName!,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}