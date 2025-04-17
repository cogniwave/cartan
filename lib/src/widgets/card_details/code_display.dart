import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cartan/src/themes/app_themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CodeDisplayWidget extends StatelessWidget {
  final String cardNumber;
  final bool showQrCode;
  final VoidCallback onZoomPressed;

  const CodeDisplayWidget({
    super.key,
    required this.cardNumber,
    required this.showQrCode,
    required this.onZoomPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0D000000),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: showQrCode
                  ? QrImageView(
                data: cardNumber,
                version: QrVersions.auto,
                size: 100,
                backgroundColor: Colors.white,
              )
                  : BarcodeWidget(
                barcode: Barcode.code128(),
                data: cardNumber,
                width: 300,
                height: 120,
                drawText: false,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            cardNumber,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onZoomPressed,
            icon: const Icon(AntIcons.searchOutlined),
            label: Text(localizations.zoom),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.extension<CustomColors>()!.accentAlt,
              foregroundColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
