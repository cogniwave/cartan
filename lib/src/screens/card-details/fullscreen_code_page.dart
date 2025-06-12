import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cartan/utils/system_brightness.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FullScreenCodePage extends StatefulWidget {
  final String cardNumber;
  final bool showQrCode;

  const FullScreenCodePage({
    super.key,
    required this.cardNumber,
    required this.showQrCode,
  });

  @override
  State<FullScreenCodePage> createState() => _FullScreenCodePageState();
}

class _FullScreenCodePageState extends State<FullScreenCodePage> {
  double _originalBrightness = 0.5;

  @override
  void initState() {
    super.initState();
    _setMaxBrightness();

    // Portrait only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    _restoreBrightness();

    // Restores all orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
  }

  Future<void> _setMaxBrightness() async {
    _originalBrightness = await SystemBrightness.brightness;
    await SystemBrightness.setBrightness(1.0);
  }

  Future<void> _restoreBrightness() async {
    await SystemBrightness.setBrightness(_originalBrightness);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    const double paddingAll = 16.0;

    final double containerWidth = widget.showQrCode
        ? screenWidth * 0.85
        : screenWidth * 0.6;

    final double containerHeight = widget.showQrCode
        ? screenWidth * 0.85
        : screenHeight * 0.8;

    final double innerWidth = containerWidth - paddingAll * 2;
    final double innerHeight = containerHeight - paddingAll * 2;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.primary),
        title: Text(
          AppLocalizations.of(context)!.back,
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: containerWidth,
            height: containerHeight,
            padding: const EdgeInsets.all(paddingAll),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: widget.showQrCode
            // QR Code
                ? Center(
              child: QrImageView(
                data: widget.cardNumber,
                version: QrVersions.auto,
                size: innerWidth.clamp(200.0, 400.0),
                backgroundColor: Colors.white,
                padding: EdgeInsets.zero,
              ),
            )
            // Barcode
                : RotatedBox(
              quarterTurns: 1,
              child: SizedBox(
                width: innerHeight,
                height: innerWidth,
                child: BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: widget.cardNumber,
                  width: innerHeight,
                  height: innerWidth,
                  drawText: false,
                  color: Colors.black,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
