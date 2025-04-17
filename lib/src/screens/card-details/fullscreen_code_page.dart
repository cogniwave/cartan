import 'package:flutter/material.dart';
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
  }

  @override
  void dispose() {
    _restoreBrightness();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.showQrCode)
              QrImageView(
                data: widget.cardNumber,
                version: QrVersions.auto,
                size: 300,
                backgroundColor: Colors.white,
              )
            else
              BarcodeWidget(
                barcode: Barcode.code128(),
                data: widget.cardNumber,
                width: 300,
                height: 150,
                drawText: false,
                color: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}