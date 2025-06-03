import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cartan/src/models/card_type_data.dart';
import 'package:cartan/src/models/card_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/src/themes/app_themes.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ManualEntryView extends StatefulWidget {
  final TextEditingController cardNumberController;
  final String? errorMessage;
  final Function(String) onCardNumberChanged;
  final Function(Map<String, dynamic>) onSave;
  final bool isValid;
  final String assetImagePath;
  final List<String> formats;
  final CardTypeData? cardTypeData;

  const ManualEntryView({
    super.key,
    required this.cardNumberController,
    this.errorMessage,
    required this.onCardNumberChanged,
    required this.onSave,
    required this.isValid,
    required this.assetImagePath,
    required this.formats,
    this.cardTypeData,
  });

  @override
  State<ManualEntryView> createState() => _ManualEntryViewState();
}

class _ManualEntryViewState extends State<ManualEntryView> {
  late CardConfiguration config;
  late List<FormFieldConfig> additionalFields;
  late Map<String, TextEditingController> additionalControllers;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeConfiguration();
  }

  void _initializeConfiguration() {
    // Determine card type based on category
    String cardType = 'loyalty'; // default
    if (widget.cardTypeData != null) {
      if (widget.cardTypeData!.isSimCard) {
        cardType = 'sim';
      } else if (widget.cardTypeData!.isLoyaltyCard) {
        cardType = 'loyalty';
      }
    }

    config = CardConfigurationFactory.getConfiguration(cardType);

    // Get additional fields based on metadata
    additionalFields = config.getFieldsFromMetadata(widget.cardTypeData?.metadata);

    // Initialize controllers for additional fields
    additionalControllers = {};
    for (var field in additionalFields) {
      additionalControllers[field.key] = TextEditingController(
          text: field.initialValue ?? ''
      );
    }
  }

  @override
  void dispose() {
    // Clean up additional controllers
    for (var controller in additionalControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  int _extractExpectedDigits() {
    final pattern = widget.formats.first;
    final match = RegExp(r'\\d\{(\d+)\}').firstMatch(pattern);
    return match != null ? int.parse(match.group(1)!) : 0;
  }

  String _getLocalizedText(AppLocalizations localizations, String key) {
    // Simple mapping for localization keys
    switch (key) {
      case 'phone_number_label':
        return 'Phone Number';
      case 'phone_number_hint':
        return 'Associated phone number';
      case 'pin_label':
        return 'PIN';
      case 'pin_hint':
        return 'SIM card PIN (4-8 digits)';
      case 'puk_label':
        return 'PUK';
      case 'puk_hint':
        return 'PUK code (8 digits)';
      default:
        return key; // Fallback
    }
  }

  Widget _buildFieldWidget(FormFieldConfig field, AppLocalizations localizations) {
    final controller = additionalControllers[field.key]!;

    switch (field.inputType) {
      case InputType.numeric:
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: _getLocalizedText(localizations, field.labelKey),
            hintText: field.hintKey != null
                ? _getLocalizedText(localizations, field.hintKey!)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            if (field.maxLength != null && field.maxLength! > 0)
              LengthLimitingTextInputFormatter(field.maxLength!),
          ],
          validator: field.isRequired
              ? (value) => value?.isEmpty == true ? 'Required field' : null
              : null,
        );

      case InputType.phone:
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: _getLocalizedText(localizations, field.labelKey),
            hintText: field.hintKey != null
                ? _getLocalizedText(localizations, field.hintKey!)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: <TextInputFormatter>[
            if (field.maxLength != null && field.maxLength! > 0)
              LengthLimitingTextInputFormatter(field.maxLength!),
          ],
          validator: field.isRequired
              ? (value) => value?.isEmpty == true ? 'Required field' : null
              : null,
        );

      case InputType.email:
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: _getLocalizedText(localizations, field.labelKey),
            hintText: field.hintKey != null
                ? _getLocalizedText(localizations, field.hintKey!)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: field.isRequired
              ? (value) => value?.isEmpty == true ? 'Required field' : null
              : null,
        );

      case InputType.multiline:
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: _getLocalizedText(localizations, field.labelKey),
            hintText: field.hintKey != null
                ? _getLocalizedText(localizations, field.hintKey!)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          maxLines: 3,
          validator: field.isRequired
              ? (value) => value?.isEmpty == true ? 'Required field' : null
              : null,
        );

      default: // InputType.text
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: _getLocalizedText(localizations, field.labelKey),
            hintText: field.hintKey != null
                ? _getLocalizedText(localizations, field.hintKey!)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          inputFormatters: <TextInputFormatter>[
            if (field.maxLength != null && field.maxLength! > 0)
              LengthLimitingTextInputFormatter(field.maxLength!),
          ],
          validator: field.isRequired
              ? (value) => value?.isEmpty == true ? 'Required field' : null
              : null,
        );
    }
  }

  void _handleSave() {
    // Validate the form if there are additional fields
    if (additionalFields.isNotEmpty && !_formKey.currentState!.validate()) {
      return;
    }

    // Collect all data
    Map<String, dynamic> allData = {
      'cardNumber': widget.cardNumberController.text,
    };

    // Add data from additional fields
    for (var field in additionalFields) {
      final value = additionalControllers[field.key]!.text;
      if (value.isNotEmpty) {
        allData[field.key] = value;
      }
    }

    // Validate using the configuration
    if (config.validateData(allData)) {
      widget.onSave(allData);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please verify the entered data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final hasSpecificFormat = widget.formats.isNotEmpty;
    final expectedDigits = hasSpecificFormat ? _extractExpectedDigits() : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 150,
                    height: 100,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: SvgPicture.asset(widget.assetImagePath),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Card number field (always present)
              TextFormField(
                controller: widget.cardNumberController,
                decoration: InputDecoration(
                  labelText: localizations.card_number,
                  errorText: widget.errorMessage,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.text,
                inputFormatters: (hasSpecificFormat && expectedDigits != null && expectedDigits > 0)
                    ? <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(expectedDigits),
                ]
                    : <TextInputFormatter>[],
                onChanged: widget.onCardNumberChanged,
                validator: (value) =>
                value?.isEmpty == true ? 'Required field' : null,
              ),

              const SizedBox(height: 12),

              if (hasSpecificFormat)
                Text(
                  localizations.format_hint,
                  style: theme.textTheme.bodySmall,
                ),

              if (hasSpecificFormat) ...[
                const SizedBox(height: 4),
                Text(
                  '($expectedDigits ${localizations.digits})',
                  style: theme.textTheme.bodySmall,
                ),
              ],

              // Additional fields based on card type
              if (additionalFields.isNotEmpty) ...[
                const SizedBox(height: 32),
                Text(
                  'Additional Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                ...additionalFields.map((field) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildFieldWidget(field, localizations),
                )),
              ],

              const SizedBox(height: 46),

              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(AntIcons.formOutlined),
                  label: Text(localizations.add_card),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.extension<CustomColors>()!.accent,
                    foregroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  onPressed: widget.isValid ? _handleSave : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}