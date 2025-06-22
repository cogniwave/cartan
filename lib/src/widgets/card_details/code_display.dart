import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cartan/src/themes/app_themes.dart';
import 'package:cartan/l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CodeDisplayWidget extends StatelessWidget {
  final String cardNumber;
  final bool showQrCode;
  final VoidCallback onZoomPressed;

  const CodeDisplayWidget({super.key, required this.cardNumber, required this.showQrCode, required this.onZoomPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    late final double qrSize;
    late final double barcodeWidth;
    late final double barcodeHeight;
    late final double verticalSpacing;
    late final double containerPadding;

    if (isLandscape) {
      qrSize = 120.0;
      barcodeWidth = 240.0;
      barcodeHeight = 80.0;
      verticalSpacing = 8.0;
      containerPadding = 12.0;
    } else {
      qrSize = 200.0;
      barcodeWidth = 300.0;
      barcodeHeight = 120.0;
      verticalSpacing = 24.0;
      containerPadding = 14.0;
    }

    return Container(
      margin: EdgeInsets.all(containerPadding),
      padding: EdgeInsets.all(containerPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child:
                  showQrCode
                      ? Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onZoomPressed,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                            child: QrImageView(
                              data: cardNumber,
                              version: QrVersions.auto,
                              size: qrSize,
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.all(8),
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
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                            child: BarcodeWidget(
                              barcode: Barcode.code128(),
                              data: cardNumber,
                              width: barcodeWidth,
                              height: barcodeHeight,
                              drawText: false,
                              color: Colors.black,
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
              padding:
                  isLandscape
                      ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                      : const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            ),
          ),
        ],
      ),
    );
  }
}
