import 'package:cartan/src/services/navigation_service.dart';
import 'package:cartan/src/widgets/common/search_results.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cartan/src/repositories/providers_repository.dart';
import 'package:cartan/src/widgets/common/searchable_app_bar.dart';
import 'scan_card_screen.dart';
import 'package:cartan/l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectProviderScreen extends StatefulWidget {
  final ProviderCategory category;

  const SelectProviderScreen({super.key, required this.category});

  @override
  State<SelectProviderScreen> createState() => _SelectProviderScreenState();
}

class _SelectProviderScreenState extends State<SelectProviderScreen> {
  String _searchQuery = '';

  String get _defaultImagePath {
    return 'lib/assets/images/default_card.svg';
  }

  String get _screenTitle {
    final localizations = AppLocalizations.of(context)!;
    switch (widget.category) {
      case ProviderCategory.loyalty:
        return localizations.select_merchant;
      case ProviderCategory.sim:
        return localizations.select_carrier;
      case ProviderCategory.membership:
        return localizations.select_merchant;
      case ProviderCategory.rewards:
        return localizations.select_merchant;
      case ProviderCategory.informative:
        return localizations.select_carrier;
      case ProviderCategory.business:
        return localizations.select_merchant;
      case ProviderCategory.other:
        return localizations.select_merchant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final providersRepo = Provider.of<ProvidersRepository>(context);
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: SearchableAppBar(
        title: _screenTitle,
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
          future: providersRepo.initialize(widget.category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            var providers = providersRepo.getAllProviders(widget.category);

            providers.sort(
              (a, b) => a.displayName.toLowerCase().compareTo(
                b.displayName.toLowerCase(),
              ),
            );

            // Filter providers based on search query
            final filteredProviders =
                _searchQuery.isEmpty
                    ? providers
                    : providers
                        .where(
                          (provider) => provider.displayName
                              .toLowerCase()
                              .contains(_searchQuery),
                        )
                        .toList();

            // Show message when no providers match the search query
            if (filteredProviders.isEmpty && _searchQuery.isNotEmpty) {
              return SearchResults.buildNoResultsFound(
                message: localizations.no_results_found,
                theme: theme,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 16, left: 0),
              itemCount: filteredProviders.length,
              itemBuilder: (context, index) {
                final provider = filteredProviders[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: SvgPicture.asset(
                      width: 100,
                      alignment: Alignment.centerLeft,
                      provider.assetImagePath,
                      errorBuilder: (context, error, stackTrace) {
                        return SvgPicture.asset(_defaultImagePath);
                      },
                    ),
                    title: Text(provider.displayName),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ScanCardScreen(provider: provider),
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
    );
  }
}

// Factory methods
class SelectMerchantScreen extends SelectProviderScreen {
  const SelectMerchantScreen({super.key})
    : super(category: ProviderCategory.loyalty);
}

class SelectCarrierScreen extends SelectProviderScreen {
  const SelectCarrierScreen({super.key})
    : super(category: ProviderCategory.sim);
}
