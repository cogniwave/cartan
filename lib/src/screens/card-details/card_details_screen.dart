import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/src/models/loyalty_card.dart';
import 'package:cartan/src/themes/app_themes.dart';
import 'package:cartan/src/widgets/card_details/code_display.dart';
import 'package:cartan/src/screens/card-details/fullscreen_code_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'card_options_screen.dart';

class CardDetailsScreen extends StatefulWidget {
  final LoyaltyCard card;

  const CardDetailsScreen({
    super.key,
    required this.card,
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
    final navigator = Navigator.of(context);

    navigator.push(
      MaterialPageRoute(
        builder: (context) => CardOptionsScreen(
          card: widget.card,
        ),
      ),
    ).then((result) {
      if (result == true && mounted) {
        navigator.pop(true);
      }
    });
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
            SvgPicture.asset(
              widget.card.provider.assetImagePath,
              width: 70,
              height: 40,
            ),
            const SizedBox(width: 8),
            Text(widget.card.provider.displayName),
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
                padding: isLandscape
                    ? const EdgeInsets.fromLTRB(24, 32, 24, 32)
                    : const EdgeInsets.fromLTRB(16, 42, 16, 42),
                child: Text(
                  formatMemberId(widget.card.memberId),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),

              if (widget.card.provider.isSimCard) ...[
                _buildSimCardInfo(theme, localizations),
                SizedBox(height: isLandscape ? 8 : 16),
              ],

              SizedBox(height: isLandscape ? 8 : 16),

              // TabBar barcode / QR
              Container(
                margin: EdgeInsets.symmetric(horizontal: isLandscape ? 24 : 16),
                child: TabBar(
                  controller: _tabController,
                  labelColor: customColors.accentAlt,
                  unselectedLabelColor: theme.colorScheme.primary,
                  indicatorColor: customColors.accentAlt,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
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
                  onZoomPressed: _openFullScreenCode,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimCardInfo(ThemeData theme, AppLocalizations localizations) {
    if (!widget.card.provider.isSimCard) return const SizedBox.shrink();

    final List<Widget> infoWidgets = [];

    if (widget.card.iccid != null) {
      infoWidgets.add(_buildInfoRow('ICCID', widget.card.iccid!, theme));
    }
    if (widget.card.msisdn != null) {
      infoWidgets.add(_buildInfoRow('MSISDN', widget.card.msisdn!, theme));
    }
    if (widget.card.pin != null) {
      infoWidgets.add(_buildInfoRow('PIN', widget.card.pin!, theme));
    }
    if (widget.card.puk != null) {
      infoWidgets.add(_buildInfoRow('PUK', widget.card.puk!, theme));
    }

    if (infoWidgets.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SIM Card Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...infoWidgets,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}