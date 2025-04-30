import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cartan/src/repositories/merchants_repository.dart';
import 'package:cartan/src/widgets/common/app_bar.dart';
import 'scan_card_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectMerchantScreen extends StatelessWidget {
  const SelectMerchantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final merchantsRepo = Provider.of<MerchantsRepository>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: Text(AppLocalizations.of(context)!.select_merchant),
            ),

            Expanded(
              child: FutureBuilder(
                future: merchantsRepo.initialize(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final merchants = merchantsRepo.getAllMerchants();

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
                            child: Image.asset(
                              merchant.assetImagePath,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(merchant.displayName),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScanCardScreen(merchant: merchant),
                              ),
                            );
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