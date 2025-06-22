import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cartan/l10n/app_localizations.dart';
import 'package:cartan/src/blocs/cards/cards_bloc.dart';
import 'package:cartan/src/models/merchant.dart';
import 'package:cartan/src/models/loyalty_card.dart';
import 'package:cartan/src/widgets/cards/manual_entry_view.dart';
import 'package:cartan/src/widgets/cards/scanner_view.dart';
import 'package:cartan/utils/card_format_validator.dart';
import 'package:cartan/utils/app_snackbar.dart';
import 'package:cartan/src/themes/app_themes.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScanCardScreen extends StatefulWidget {
  final Merchant merchant;
  const ScanCardScreen({super.key, required this.merchant});

  @override
  State<ScanCardScreen> createState() => _ScanCardScreenState();
}

class _ScanCardScreenState extends State<ScanCardScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _codeController = TextEditingController();
  late TabController _tabController;

  bool _isValid = false;
  String? _errorMessage;

  bool _hasCameraPermission = false;
  bool _checkingPermission = true;

  AppLocalizations get localizations => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)..addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestCameraPermission();
    });
  }

  Future<void> _requestCameraPermission() async {
    setState(() => _checkingPermission = true);
    final status = await Permission.camera.request();
    setState(() {
      _hasCameraPermission = status.isGranted;
      _checkingPermission = false;
    });
  }

  Future<void> _openAppSettings() async {
    await openAppSettings();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _validateCode(String code) {
    final memberId = code.trim();

    final formats = widget.merchant.formats;
    final formatValid = CardFormatValidator().isValidFormat(memberId, formats);

    if (!formatValid) {
      setState(() {
        _isValid = false;
        _errorMessage =
            formats.isEmpty ? localizations.invalid_card_not_empty_alphanumeric : localizations.invalid_card_format;
      });
      return;
    }

    // Duplicates val
    final bloc = context.read<CardsBloc>();
    final duplicate = bloc.state.cards.any((c) => c.merchant.id == widget.merchant.id && c.memberId == memberId);
    if (duplicate) {
      setState(() {
        _isValid = false;
        _errorMessage = localizations.card_already_exists;
      });
      return;
    }

    // Tudo OK
    setState(() {
      _isValid = true;
      _errorMessage = null;
    });
  }

  void _handleCodeDetected(String code) {
    _codeController.text = code;
    _validateCode(code);
    if (_isValid) _tabController.animateTo(1);
  }

  void _saveCard() {
    if (!_isValid) return;

    final newCard = LoyaltyCard(merchant: widget.merchant, memberId: _codeController.text.trim());
    context.read<CardsBloc>().add(AddCard(newCard));

    AppSnackBar.showSuccess(localizations.card_added_successfully);
    Navigator.pop(context, true);
  }

  Widget _buildScannerTab(ThemeData theme) {
    if (_checkingPermission) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!_hasCameraPermission) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AntIcons.cameraOutlined, size: 64, color: theme.colorScheme.secondary),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                localizations.camera_permission_required,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _openAppSettings, child: Text(localizations.open_settings)),
          ],
        ),
      );
    }
    return ScannerView(onCodeDetected: _handleCodeDetected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final custom = theme.extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.dividerTheme.color,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                width: 50,
                height: 30,
                child: FittedBox(fit: BoxFit.fill, child: SvgPicture.asset(widget.merchant.assetImagePath)),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                widget.merchant.displayName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: theme.textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: theme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: custom.accentAlt,
              unselectedLabelColor: theme.colorScheme.primary,
              indicatorColor: custom.accentAlt,
              dividerColor: Colors.transparent,
              tabs: [Tab(text: localizations.scan_barcode), Tab(text: localizations.enter_manually)],
            ),
          ),
          Expanded(
            child: Container(
              color: theme.colorScheme.surface,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildScannerTab(theme),
                  ManualEntryView(
                    controller: _codeController,
                    errorMessage: _errorMessage,
                    onChanged: _validateCode,
                    onSave: _saveCard,
                    isValid: _isValid,
                    assetImagePath: widget.merchant.assetImagePath,
                    formats: widget.merchant.formats,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
