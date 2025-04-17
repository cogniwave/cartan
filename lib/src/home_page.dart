import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cartan/src/screens/card-details/card_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:cartan/src/screens/add_card/select_merchant_screen.dart';
import 'package:cartan/src/screens/settings_screen.dart';
import 'package:cartan/src/repositories/loyalty_card_repository.dart';
import 'package:cartan/src/repositories/merchants_repository.dart';
import 'package:cartan/src/models/loyalty_card.dart';
import 'package:cartan/src/widgets/home_page/add_card_button.dart';
import 'package:cartan/src/widgets/home_page/empty_cards_view.dart';
import 'package:cartan/src/widgets/home_page/cards_list_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<LoyaltyCard>? _cards;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final merchantsRepo = Provider.of<MerchantsRepository>(context, listen: false);
    if (!merchantsRepo.isInitialized) {
      await merchantsRepo.initialize();
    }

    final cardRepo = Provider.of<LoyaltyCardRepository>(context, listen: false);
    final loadedCards = await cardRepo.getAllCards();

    if (mounted) {
      setState(() {
        _cards = loadedCards;
      });
    }
  }

  void _navigateToSelectMerchant() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectMerchantScreen()),
    ).then((_) => _loadData());
  }

  void _navigateToCardDetails(LoyaltyCard card) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardDetailsScreen(
          card: card,
          merchant: card.merchant,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          localizations.cards,
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(AntIcons.reloadOutlined, color: theme.colorScheme.primary),
            onPressed: _loadData,
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: theme.colorScheme.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: (_cards?.isEmpty ?? true)
          ? EmptyCardsView(
        onAddPressed: _navigateToSelectMerchant,
      )
          : Stack(
        children: [
          CardsListView(
            cards: _cards!,
            onCardTap: _navigateToCardDetails,
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: AddCardButton(
              onPressed: _navigateToSelectMerchant,
            ),
          ),
        ],
      ),
    );
  }
}
