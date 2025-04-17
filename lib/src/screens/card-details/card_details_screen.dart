import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/src/models/merchant.dart';
import 'package:cartan/src/models/loyalty_card.dart';
import 'package:cartan/src/themes/app_themes.dart';
import 'package:cartan/src/widgets/card_details/code_display.dart';

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
  // _showQrCode pode ser derivado do índice do TabController
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

  /*void _openFullScreenCode() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenCodePage(
          cardNumber: widget.card.cardNumber,
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
  }*/

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.primary),
        title: Text(
          widget.merchant.displayName,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, size: 24),
            onPressed: () {
              // TODO: _navigateToOptions
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        widget.merchant.assetImagePath,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.merchant.displayName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.card.memberId,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // TabBar barcode / QR
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
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

              const SizedBox(height: 16),

              // Barcode or QR Code
              Container(
                height: MediaQuery.of(context).size.height * 0.4, // ajuste conforme necessário
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CodeDisplayWidget(
                  cardNumber: widget.card.memberId,
                  showQrCode: _showQrCode,
                  onZoomPressed: () {
                    // TODO: _openFullScreenCode
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}