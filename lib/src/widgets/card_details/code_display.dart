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
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final qrSize = isLandscape ? 120.0 : 200.0;
    final barcodeWidth = isLandscape ? 240.0 : 300.0;
    final barcodeHeight = isLandscape ? 80.0 : 120.0;

    final verticalSpacing = isLandscape ? 8.0 : 24.0;
    final containerPadding = isLandscape ? 12.0 : 14.0;

    final qrPadding = isLandscape
        ? EdgeInsets.all(containerPadding)
        : EdgeInsets.symmetric(
        horizontal: containerPadding, vertical: containerPadding);

    return Container(
      margin: EdgeInsets.all(containerPadding),
      padding: EdgeInsets.all(containerPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: showQrCode
                  ? Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onZoomPressed,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: qrSize,
                    height: qrSize,
                    padding: qrPadding,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: QrImageView(
                        data: cardNumber,
                        version: QrVersions.auto,
                        size: qrSize,
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              )
                  : Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onZoomPressed,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: cardNumber,
                      width: barcodeWidth,
                      height: barcodeHeight,
                      drawText: false,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: verticalSpacing),
          ElevatedButton.icon(
            onPressed: onZoomPressed,
            icon: Icon(AntIcons.searchOutlined, size: isLandscape ? 16 : 24),
            label: Text(AppLocalizations.of(context)!.zoom),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.extension<CustomColors>()!.accentAlt,
              foregroundColor: theme.colorScheme.primary,
              padding: isLandscape
                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                  : const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
