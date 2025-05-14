import 'package:cartan/src/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cartan/src/repositories/merchants_repository.dart';
import 'package:cartan/src/widgets/common/app_bar.dart';
import 'scan_card_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: Text(localizations.select_merchant),
            ),

            // search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: localizations.search,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),

            Expanded(
              child: FutureBuilder(
                future: merchantsRepo.initialize(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var merchants = merchantsRepo.getAllMerchants();

                  merchants.sort((a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));

                  if (_searchQuery.isNotEmpty) {
                    merchants = merchants.where((merchant) {
                      return merchant.displayName.toLowerCase().contains(_searchQuery);
                    }).toList();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 16),
                    itemCount: merchants.length,
                    itemBuilder: (context, index) {
                      final merchant = merchants[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 80,
                              height: 50,
                              child: Image.asset(
                                merchant.assetImagePath,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'lib/assets/images/loyalty_cards/card.svg',
                                    fit: BoxFit.fill,
                                  );
                                },
                              ),
                            ),
                          ),
                          title: Text(merchant.displayName),
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
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}