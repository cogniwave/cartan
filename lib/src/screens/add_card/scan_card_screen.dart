import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cartan/src/models/merchant.dart';
import 'package:cartan/src/models/loyalty_card.dart';
import 'package:cartan/src/widgets/add_card_views/manual_entry_view.dart';
import 'package:cartan/src/widgets/add_card_views/scanner_view.dart';
import 'package:cartan/src/repositories/loyalty_card_repository.dart';
import 'package:cartan/utils/card_format_validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/utils/app_snackbar.dart';
import 'package:cartan/src/themes/app_themes.dart';

class ScanCardScreen extends StatefulWidget {
  final Merchant merchant;

  const ScanCardScreen({super.key, required this.merchant});

  @override
  _ScanCardScreenState createState() => _ScanCardScreenState();
}

class _ScanCardScreenState extends State<ScanCardScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _codeController = TextEditingController();
  bool _isValid = false;
  String? _errorMessage;
  late TabController _tabController;
  AppLocalizations get localizations => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    setState(() {
    });
  }

  void _validateCode(String code) {
    final validator = CardFormatValidator();
    final isValid = validator.isValidFormat(code, widget.merchant.formats);

    setState(() {
      _isValid = isValid;
      _errorMessage = isValid ? null : localizations.invalid_card_format;
    });
  }

  void _handleCodeDetected(String code) {
    _codeController.text = code;
    _validateCode(code);

    if (_isValid) {
      _tabController.animateTo(1);
    }
  }

  void _saveCard() async {
    if (!_isValid) return;

    final cardRepo = Provider.of<LoyaltyCardRepository>(context, listen: false);
    final newCard = LoyaltyCard(
      merchant: widget.merchant,
      memberId: _codeController.text.trim(),
    );

    await cardRepo.saveCard(newCard);

    if (!mounted) return;
    Navigator.popUntil(context, (route) => route.isFirst);
    AppSnackBar.showSuccess(context, localizations.card_added_successfully);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final customColor = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.dividerTheme.color,
        title: Row(
          children: [
            Image.asset(
              widget.merchant.assetImagePath,
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 8),
            Text(widget.merchant.displayName),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: theme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: customColor.accentAlt,
              indicatorColor: customColor.accentAlt,
              unselectedLabelColor: theme.colorScheme.primary,
              tabs: [
                Tab(text: localizations.scan_barcode),
                Tab(text: localizations.enter_manually),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: theme.colorScheme.surface,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Scan tab
                  ScannerView(onCodeDetected: _handleCodeDetected),
                  // Manual entry tab
                  ManualEntryView(
                    controller: _codeController,
                    errorMessage: _errorMessage,
                    onChanged: _validateCode,
                    onSave: _saveCard,
                    isValid: _isValid,
                    assetImagePath: widget.merchant.assetImagePath,
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
