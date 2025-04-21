import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/src/models/merchant.dart';
import 'package:cartan/src/models/loyalty_card.dart';
import 'package:cartan/src/themes/app_themes.dart';
import 'package:cartan/src/widgets/card_details/code_display.dart';
import 'package:cartan/src/screens/card-details/fullscreen_code_page.dart';
import 'card_options_screen.dart';

class CardDetailsScreen extends StatefulWidget {
  final LoyaltyCard card;
  final Merchant merchant;

  const CardDetailsScreen({
    super.key,
    required this.card,
    required this.merchant,
  });

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool get _showQrCode => _tabController.index == 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openFullScreenCode() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenCodePage(
          cardNumber: widget.card.memberId,
          showQrCode: _showQrCode,
        ),
      ),
    );
  }

  void _navigateToOptions() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CardOptionsScreen(
          card: widget.card,
          merchant: widget.merchant,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    final localizations = AppLocalizations.of(context)!;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    String formatMemberId(String id) {
      return id.replaceAllMapped(RegExp(r'.{1,3}'), (match) => '${match.group(0)} ').trim();
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.primary),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, size: 24),
            onPressed: () {
              _navigateToOptions();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isLandscape ? 24 : 16,
                  isLandscape ? 32 : 42,
                  isLandscape ? 24 : 16,
                  0,
                ),
                child: Text(
                  formatMemberId(widget.card.memberId),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),

              SizedBox(height: isLandscape ? 8 : 16),

              // TabBar barcode / QR
              Container(
                margin: EdgeInsets.symmetric(horizontal: isLandscape ? 24 : 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: customColors.accentAlt,
                  unselectedLabelColor: theme.colorScheme.primary,
                  indicatorColor: customColors.accentAlt,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(text: localizations.barcode),
                    Tab(text: localizations.qr_code),
                  ],
                ),
              ),

              SizedBox(height: isLandscape ? 8 : 16),

              SizedBox(
                height: isLandscape ? 240 : 360,
                child: CodeDisplayWidget(
                  cardNumber: widget.card.memberId,
                  showQrCode: _showQrCode,
                  onZoomPressed: _openFullScreenCode, // Usar a função já definida
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}