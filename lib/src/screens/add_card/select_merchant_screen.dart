import 'package:cartan/src/services/navigation_service.dart';
import 'package:cartan/src/widgets/common/search_results.dart';
import 'package:cartan/utils/custom_tap.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cartan/src/repositories/merchants_repository.dart';
import 'package:cartan/src/widgets/common/searchable_app_bar.dart';
import 'scan_card_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectMerchantScreen extends StatefulWidget {
  const SelectMerchantScreen({super.key});

  @override
  State<SelectMerchantScreen> createState() => _SelectMerchantScreenState();
}

class _SelectMerchantScreenState extends State<SelectMerchantScreen> {
  String _searchQuery = '';


  @override
  Widget build(BuildContext context) {
    final merchantsRepo = Provider.of<MerchantsRepository>(context);
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: SearchableAppBar(
        title: localizations.select_merchant,
        searchHint: localizations.search,
        backgroundColor: theme.dividerTheme.color,
        onSearch: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: merchantsRepo.initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            var merchants = merchantsRepo.getAllMerchants();

            merchants.sort((a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));

            // Filter merchants based on search query
            final queryNormalized = removeDiacritics(_searchQuery.toLowerCase());

            final filteredMerchants = _searchQuery.isEmpty
                ? merchants
                : merchants.where((merchant) {
              final nameNormalized = removeDiacritics(merchant.displayName.toLowerCase());
              return nameNormalized.contains(queryNormalized);
            }).toList();


            // Show message when no merchants match the search query
            if (filteredMerchants.isEmpty && _searchQuery.isNotEmpty) {
              return SearchResults.buildNoResultsFound(message: localizations.no_results_found, theme: theme);
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 16, left: 0),
              itemCount: filteredMerchants.length,
              itemBuilder: (context, index) {
                final merchant = filteredMerchants[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CustomTap(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScanCardScreen(merchant: merchant),
                        ),
                      ).then((result) {
                        if (result == true) {
                          NavigationService().pop(true);
                        }
                      });
                    },
                    child: ListTile(
                      leading: SvgPicture.asset(
                        merchant.assetImagePath,
                        width: 100,
                        alignment: Alignment.centerLeft,
                        errorBuilder: (context, error, stackTrace) {
                          return SvgPicture.asset(
                            'lib/assets/images/loyalty_cards/default_card.svg',
                          );
                        },
                      ),
                      title: Text(merchant.displayName),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}