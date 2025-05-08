import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/src/blocs/merchants/merchants_bloc.dart';
import 'package:cartan/src/blocs/merchants/merchants_state.dart';
import 'package:cartan/src/models/merchant.dart';
import 'scan_card_screen.dart';
import 'package:cartan/src/widgets/common/app_bar.dart';

class SelectMerchantScreen extends StatefulWidget {
  const SelectMerchantScreen({super.key});
  @override
  State<SelectMerchantScreen> createState() => _SelectMerchantScreenState();
}

class _SelectMerchantScreenState extends State<SelectMerchantScreen> {
  String _searchQuery = '';

  /// Filter helper
  List<Merchant> _filter(List<Merchant> all) {
    if (_searchQuery.isEmpty) return all;
    return all
        .where((m) =>
        m.displayName.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: Text(local.select_merchant)),

            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: local.search,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
              ),
            ),

            // Merchants list via Bloc
            Expanded(
              child: BlocBuilder<MerchantsBloc, MerchantsState>(
                builder: (context, state) {
                  if (state is MerchantsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is MerchantsError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  final merchants =
                  (state as MerchantsLoaded).merchants..sort(
                          (a, b) => a.displayName
                          .toLowerCase()
                          .compareTo(b.displayName.toLowerCase()));

                  final filtered = _filter(merchants);

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 16),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) {
                      final merchant = filtered[i];
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
                              errorBuilder: (_, __, ___) => Image.asset(
                                'lib/assets/images/loyalty_cards/card.png',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(merchant.displayName),
                          onTap: () async {
                            // Navigate & handle async safely
                            final added = await Navigator.of(context).push<bool>(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ScanCardScreen(merchant: merchant),
                              ),
                            );
                            if (!context.mounted) return;
                            if (added == true) {
                              Navigator.of(context).pop(true);
                            }
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