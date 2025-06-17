import 'package:cartan/src/forms/card_form_manager.dart';
import 'package:cartan/src/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/src/blocs/cards/cards_bloc.dart';
import 'package:cartan/src/models/provider_model.dart';
import 'package:cartan/src/models/card_model.dart';
import 'package:cartan/src/widgets/cards/manual_entry_view.dart';
import 'package:cartan/src/widgets/cards/scanner_view.dart';
import 'package:cartan/src/widgets/cards/ocr_scanner_view.dart';
import 'package:cartan/utils/card_format_validator.dart';
import 'package:cartan/utils/app_snackbar.dart';
import 'package:cartan/src/themes/app_themes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cartan/src/models/card_type_data.dart';
import 'package:cartan/src/models/card_configuration.dart';

class ScanCardScreen extends StatefulWidget {
  final Provider provider;

  const ScanCardScreen({super.key, required this.provider});

  @override
  State<ScanCardScreen> createState() => _ScanCardScreenState();
}

class _ScanCardScreenState extends State<ScanCardScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _cardNumberController = TextEditingController();

  CardFormManager? _cardFormManager;
  late TabController _tabController;

  bool _isValid = false;

  bool _hasCameraPermission = false;
  bool _checkingPermission = true;

  AppLocalizations get localizations => AppLocalizations.of(context)!;

  // Determine if this card type should use OCR
  bool get _shouldUseOCR => widget.provider.category.toLowerCase() == 'sim';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() => setState(() {}));

    _initializeCardFormManager();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestCameraPermission();
    });
  }

  void _initializeCardFormManager() {
    // Determine card type based on provider.category
    final cardType = widget.provider.category.toLowerCase();

    // Create CardTypeData with appropriate metadata
    final cardTypeData = CardTypeData(
      id: widget.provider.id,
      displayName: widget.provider.displayName,
      formats: widget.provider.formats,
      assetImagePath: widget.provider.assetImagePath,
      website: widget.provider.website,
      category: cardType,
      metadata: _createMetadataForCardType(cardType),
    );

    // Get the configuration for this card type
    final config = CardConfigurationFactory.fromJson(cardTypeData.toJson());

    // Initialize the form manager
    _cardFormManager = CardFormManager(
      cardTypeData: cardTypeData,
      config: config,
    );
  }

  Map<String, dynamic>? _createMetadataForCardType(String cardType) {
    switch (cardType) {
      case 'sim':
        return {
          'phone_number': true,
          'pin': true,
          'puk': true,
        };
      case 'business':
        return {
          'name': true,
          'company': true,
          'email': true,
          'phone': true,
          'position': false, // optional
          'address': false, // optional
        };
      case 'membership':
        return {
          'memberName': true,
          'memberType': false, // optional
          'expiryDate': false, // optional
        };
      case 'rewards':
        return {
          'points': false,      // optional
          'memberName': false,  // optional
          'tier': false,        // optional
        };
      case 'informative':
        return {
          'description': true,
          'instructions': false,
        };
      case 'other':
        return <String, dynamic>{};
      case 'loyalty':
      default:
        return null;
    }
  }

  Future<void> _requestCameraPermission() async {
    setState(() => _checkingPermission = true);
    final status = await Permission.camera.request();
    setState(() {
      _hasCameraPermission = status.isGranted;
      _checkingPermission = false;
    });
  }

  Future<void> _openAppSettings() async {
    await openAppSettings();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardFormManager?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _validateCode(String code) {
    final memberId = code.trim();
    final formats = widget.provider.formats;
    final formatValid = CardFormatValidator().isValidFormat(memberId, formats);

    if (!formatValid) {
      setState(() {
        _isValid = false;
      });
      return;
    }

    // Check for duplicates
    final bloc = context.read<CardsBloc>();
    final duplicate = bloc.state.cards.any(
          (c) => c.provider.id == widget.provider.id && c.memberId == memberId,
    );
    if (duplicate) {
      setState(() {
        _isValid = false;
      });
      return;
    }

    setState(() {
      _isValid = true;
    });
  }

  void _handleCodeDetected(String code) {
    _cardNumberController.text = code;
    _validateCode(code);
    if (_isValid) _tabController.animateTo(1);
  }

  // New method to handle OCR data detection
  void _handleOCRDataDetected(Map<String, String> ocrData) {

    // Populate form fields with detected data
    if (_cardFormManager != null) {
      ocrData.forEach((key, value) {
        final controller = _cardFormManager!.getController(key);
        if (controller != null) {
          controller.text = value;
        }
      });
    }

    // Switch to manual entry tab to show the populated form
    _tabController.animateTo(1);

    // Show success message
    AppSnackBar.showSuccess(localizations.ocr_data_detected);
  }

  void _saveCard(Map<String, dynamic> allData) {
    // Validate additional fields if needed
    if (_cardFormManager != null && !_cardFormManager!.validateAll()) {
      AppSnackBar.showError(localizations.verify_entered_data);
      return;
    }

    final newCard = _createCardModel(allData);

    context.read<CardsBloc>().add(AddCard(newCard));

    NavigationService().navigatorKey.currentState
        ?.popUntil((route) => route.isFirst);
    AppSnackBar.showSuccess(localizations.card_added_successfully);
  }

  CardModel _createCardModel(Map<String, dynamic> allData) {
    final cardType = _cardFormManager?.cardTypeData.category ?? 'loyalty';
    final memberId = allData['cardNumber']?.toString().trim() ?? '';

    switch (cardType.toLowerCase()) {
      case 'sim':
        return SimCard(
          provider: widget.provider,
          memberId: memberId,
          phoneNumber: _getOptionalStringValue(allData, 'phone_number'),
          pin: _getOptionalStringValue(allData, 'pin'),
          puk: _getOptionalStringValue(allData, 'puk'),
        );

      case 'business':
        return BusinessCard(
          provider: widget.provider,
          memberId: memberId,
          displayName: _getOptionalStringValue(allData, 'name'),
          company: _getOptionalStringValue(allData, 'company'),
          email: _getOptionalStringValue(allData, 'email'),
          phone: _getOptionalStringValue(allData, 'phone'),
          position: _getOptionalStringValue(allData, 'position'),
          address: _getOptionalStringValue(allData, 'address'),
        );

      case 'membership':
        return MembershipCard(
          provider: widget.provider,
          memberId: memberId,
          memberName: _getOptionalStringValue(allData, 'memberName'),
          memberType: _getOptionalStringValue(allData, 'memberType'),
          expiryDate: _getOptionalStringValue(allData, 'expiryDate'),
        );

      case 'rewards':
        return RewardsCard(
          provider: widget.provider,
          memberId: memberId,
          points: _getOptionalStringValue(allData, 'points'),
          memberName: _getOptionalStringValue(allData, 'memberName'),
          tier: _getOptionalStringValue(allData, 'tier'),
        );

      case 'informative':
        return InformativeCard(
          provider: widget.provider,
          memberId: memberId,
          description: _getOptionalStringValue(allData, 'description'),
          instructions: allData['instructions'] is List
              ? List<String>.from(allData['instructions'] as List<dynamic>)
              : null,
        );

      case 'other':
        return OtherCard(
          provider: widget.provider,
          memberId: memberId,
          extraData: allData,
        );

      case 'loyalty':
      default:
        return LoyaltyCard(
          provider: widget.provider,
          memberId: memberId,
        );
    }
  }

  String? _getOptionalStringValue(Map<String, dynamic> data, String key) {
    final value = data[key]?.toString().trim();
    return (value == null || value.isEmpty) ? null : value;
  }

  Widget _buildScannerTab(ThemeData theme) {
    if (_checkingPermission) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!_hasCameraPermission) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AntIcons.cameraOutlined,
              size: 64,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                localizations.camera_permission_required,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _openAppSettings,
              child: Text(localizations.open_settings),
            ),
          ],
        ),
      );
    }

    // Return appropriate scanner based on card type
    if (_shouldUseOCR) {
      return OCRScannerView(onDataDetected: _handleOCRDataDetected);
    } else {
      return ScannerView(onCodeDetected: _handleCodeDetected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final custom = theme.extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.dividerTheme.color,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                width: 50,
                height: 30,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: SvgPicture.asset(widget.provider.assetImagePath),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(widget.provider.displayName),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: theme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: custom.accentAlt,
              unselectedLabelColor: theme.colorScheme.primary,
              indicatorColor: custom.accentAlt,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  text: _shouldUseOCR
                      ? localizations.scan_ocr
                      : localizations.scan_barcode,
                ),
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
                  _buildScannerTab(theme),
                  ManualEntryView(
                    cardNumberController: _cardNumberController,
                    onSave: _saveCard,
                    assetImagePath: widget.provider.assetImagePath,
                    formats: widget.provider.formats,
                    formManager: _cardFormManager,
                    cardType: widget.provider.category.toLowerCase(),
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