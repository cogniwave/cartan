import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// The name of the application, displayed as the app title.
  ///
  /// In pt, this message translates to:
  /// **'Cartan'**
  String get title;

  /// The title used in the AppBar for the cards section.
  ///
  /// In pt, this message translates to:
  /// **'Cartões'**
  String get cards;

  /// Message displayed on the Home page when no cards are associated.
  ///
  /// In pt, this message translates to:
  /// **'Ainda não tens cartões associados'**
  String get empty_cards;

  /// Label for the button used to add a new card.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar'**
  String get add;

  /// Label for the help option in the menu.
  ///
  /// In pt, this message translates to:
  /// **'Ajuda'**
  String get help;

  /// Label for the settings option in the menu.
  ///
  /// In pt, this message translates to:
  /// **'Definições'**
  String get settings;

  /// Feedback message displayed in a SnackBar when an operation succeeds.
  ///
  /// In pt, this message translates to:
  /// **'Operação realizada com sucesso!'**
  String get success;

  /// Error message displayed in a SnackBar when an operation fails.
  ///
  /// In pt, this message translates to:
  /// **'Ocorreu um erro ao processar a sua solicitação.'**
  String get error;

  /// Label for the button used to close the SnackBar.
  ///
  /// In pt, this message translates to:
  /// **'Fechar'**
  String get close;

  /// Menu option for app language.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get language;

  /// Menu option for dark mode.
  ///
  /// In pt, this message translates to:
  /// **'Modo escuro'**
  String get dark_mode;

  /// Menu option for app text size.
  ///
  /// In pt, this message translates to:
  /// **'Tamanho da letra'**
  String get font_size;

  /// Menu option for app Terms of Service.
  ///
  /// In pt, this message translates to:
  /// **'Termos de utilização'**
  String get terms_of_service;

  /// Menu option for app Privacy Policy.
  ///
  /// In pt, this message translates to:
  /// **'Política de privacidade'**
  String get privacy_policy;

  /// Menu option for user Feedback.
  ///
  /// In pt, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// Option for selecting a large font size.
  ///
  /// In pt, this message translates to:
  /// **'Grande'**
  String get large_font;

  /// Option for selecting the normal font size.
  ///
  /// In pt, this message translates to:
  /// **'Normal'**
  String get normal_font;

  /// Option for selecting a small font size.
  ///
  /// In pt, this message translates to:
  /// **'Pequena'**
  String get small_font;

  /// Label for selecting a store or merchant.
  ///
  /// In pt, this message translates to:
  /// **'Selecionar loja'**
  String get select_merchant;

  /// Option to scan the barcode on a loyalty card.
  ///
  /// In pt, this message translates to:
  /// **'Digitalizar código'**
  String get scan_barcode;

  /// Option to manually enter the card number.
  ///
  /// In pt, this message translates to:
  /// **'Inserir manualmente'**
  String get enter_manually;

  /// Instruction to help user align barcode for scanning.
  ///
  /// In pt, this message translates to:
  /// **'Posicione o código de barras dentro da moldura'**
  String get position_barcode_in_frame;

  /// Tip to improve barcode scanning success.
  ///
  /// In pt, this message translates to:
  /// **'Certifique-se de que o código de barras está bem iluminado e claramente visível'**
  String get scanning_hint;

  /// Label for the field where the card number is entered.
  ///
  /// In pt, this message translates to:
  /// **'Número do cartão'**
  String get card_number;

  /// Hint for the field where the card number is entered.
  ///
  /// In pt, this message translates to:
  /// **'Introduza o número do cartão'**
  String get card_number_hint;

  /// Button or label to confirm adding a new loyalty card.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar cartão'**
  String get add_card;

  /// Error message shown when the card number format is incorrect.
  ///
  /// In pt, this message translates to:
  /// **'Formato de cartão inválido'**
  String get invalid_card_format;

  /// Message confirming that the card has been successfully added.
  ///
  /// In pt, this message translates to:
  /// **'Cartão adicionado com sucesso'**
  String get card_added_successfully;

  /// Label for the barcode tab.
  ///
  /// In pt, this message translates to:
  /// **'Código de barras'**
  String get barcode;

  /// Label for the QR code tab.
  ///
  /// In pt, this message translates to:
  /// **'QR Code'**
  String get qr_code;

  /// Label for the zoom button to enlarge the code.
  ///
  /// In pt, this message translates to:
  /// **'Ampliar'**
  String get zoom;

  /// Label for the back button on fullscreen code mode.
  ///
  /// In pt, this message translates to:
  /// **'Voltar'**
  String get back;

  /// Label for the nearest places section.
  ///
  /// In pt, this message translates to:
  /// **'Locais mais próximos'**
  String get nearest_places;

  /// Label for the website link.
  ///
  /// In pt, this message translates to:
  /// **'Website'**
  String get website;

  /// Label for the remove action.
  ///
  /// In pt, this message translates to:
  /// **'Remover'**
  String get remove;

  /// Title of the dialog asking for confirmation before deleting a card.
  ///
  /// In pt, this message translates to:
  /// **'Eliminar cartão'**
  String get confirm_delete;

  /// Message shown in the dialog asking for delete confirmation.
  ///
  /// In pt, this message translates to:
  /// **'Tem a certeza de que pretende remover este cartão? Esta ação não pode ser anulada.'**
  String get confirm_delete_message;

  /// Label for the cancel button.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// Label for the confirm button.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// Message shown when a card is successfully deleted.
  ///
  /// In pt, this message translates to:
  /// **'Cartão eliminado com sucesso.'**
  String get card_deleted_successfully;

  /// Error message shown when card deletion fails.
  ///
  /// In pt, this message translates to:
  /// **'Ocorreu um erro ao eliminar o cartão.'**
  String get error_deleting_card;

  /// Displayed when the user has no map applications available to navigate.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma aplicação de mapas instalada'**
  String get no_map_apps_installed;

  /// Label for the search input field.
  ///
  /// In pt, this message translates to:
  /// **'Procurar'**
  String get search;

  /// Message informing the user that camera permission is needed.
  ///
  /// In pt, this message translates to:
  /// **'É necessário dar acesso à câmara para ler o seu cartão.'**
  String get camera_permission_required;

  /// Button label to open the device settings for the app.
  ///
  /// In pt, this message translates to:
  /// **'Abrir definições da aplicação'**
  String get open_settings;

  /// Digit count based on card number format.
  ///
  /// In pt, this message translates to:
  /// **'dígitos'**
  String get digits;

  /// Label for the name field in feedback form
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get name;

  /// Label for the email field in feedback form
  ///
  /// In pt, this message translates to:
  /// **'Email'**
  String get email;

  /// Label for the message field in feedback form
  ///
  /// In pt, this message translates to:
  /// **'Mensagem'**
  String get message;

  /// Label for the send feedback button
  ///
  /// In pt, this message translates to:
  /// **'Submeter feedback'**
  String get submit;

  /// Snackbar message after feedback is sent
  ///
  /// In pt, this message translates to:
  /// **'Obrigado pelo seu feedback!'**
  String get feedback_sent;

  /// Validation error shown when the name field is empty in the feedback form.
  ///
  /// In pt, this message translates to:
  /// **'O nome é obrigatório.'**
  String get name_required;

  /// Validation error shown when the email field is empty in the feedback form.
  ///
  /// In pt, this message translates to:
  /// **'O e-mail é obrigatório.'**
  String get email_required;

  /// Validation error shown when the supplied email does not match a valid format.
  ///
  /// In pt, this message translates to:
  /// **'Por favor, insira um endereço de e-mail válido.'**
  String get invalid_email;

  /// Validation error shown when the feedback message field is empty.
  ///
  /// In pt, this message translates to:
  /// **'Por favor, escreva a sua mensagem.'**
  String get message_required;

  /// Error message shown when feedback submission to the server fails.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível enviar a sua mensagem. Tente novamente mais tarde.'**
  String get feedback_submission_error;

  /// Error message shown when the user tries to add a loyalty card that already exists for the same merchant.
  ///
  /// In pt, this message translates to:
  /// **'Já existe um cartão deste comerciante com esse número.'**
  String get card_already_exists;

  /// Message shown when there's no match for search query.
  ///
  /// In pt, this message translates to:
  /// **'Sem resultados'**
  String get no_results_found;

  /// Error when no specific format is defined and code is invalid
  ///
  /// In pt, this message translates to:
  /// **'Campo alfanumérico e não pode estar vazio.'**
  String get invalid_card_not_empty_alphanumeric;

  /// Label for selecting card type
  ///
  /// In pt, this message translates to:
  /// **'Tipo de cartão'**
  String get card_type;

  /// Label for selecting a carrier.
  ///
  /// In pt, this message translates to:
  /// **'Selecione operadora'**
  String get select_carrier;

  /// Label for phone number.
  ///
  /// In pt, this message translates to:
  /// **'Nº de telefone'**
  String get phone_number;

  /// Label for phone number hint.
  ///
  /// In pt, this message translates to:
  /// **'Nº de telefone associado'**
  String get phone_number_hint;

  /// Label for PIN number.
  ///
  /// In pt, this message translates to:
  /// **'PIN'**
  String get pin_label;

  /// Label for PIN hint.
  ///
  /// In pt, this message translates to:
  /// **'PIN do cartão SIM (4-8 digitos)'**
  String get pin_hint;

  /// Label for PUK number.
  ///
  /// In pt, this message translates to:
  /// **'PUK'**
  String get puk_label;

  /// Label for PUK hint.
  ///
  /// In pt, this message translates to:
  /// **'Código PUK (8 digitos)'**
  String get puk_hint;

  /// Label for SIM card information.
  ///
  /// In pt, this message translates to:
  /// **'Informação do cartão'**
  String get sim_card_information;

  /// Label for SIM card details.
  ///
  /// In pt, this message translates to:
  /// **'Detalhes do cartão'**
  String get sim_card_details;

  /// Label for required field.
  ///
  /// In pt, this message translates to:
  /// **'Campo obrigatório'**
  String get required_field;

  /// Label for errors in entered data snackbar.
  ///
  /// In pt, this message translates to:
  /// **'Por favor, verifique os dados introduzidos'**
  String get verify_entered_data;

  /// Error label for invalid phone number format.
  ///
  /// In pt, this message translates to:
  /// **'Nº de telefone inválido'**
  String get invalid_phone_number;

  /// Label for scan OCR action.
  ///
  /// In pt, this message translates to:
  /// **'Digitalizar'**
  String get scan_ocr;

  /// Instruction to position the SIM card within the camera frame.
  ///
  /// In pt, this message translates to:
  /// **'Posicione o cartão SIM dentro da moldura'**
  String get position_sim_card_in_frame;

  /// Detailed instructions for performing the OCR scan.
  ///
  /// In pt, this message translates to:
  /// **'Mantenha o cartão estável e bem iluminado. O PIN e PUK serão detectados automaticamente.'**
  String get ocr_scanning_instructions;

  /// Label shown while OCR processing is ongoing.
  ///
  /// In pt, this message translates to:
  /// **'A processar...'**
  String get processing;

  /// Heading for the section where detected OCR data is displayed.
  ///
  /// In pt, this message translates to:
  /// **'Dados detectados:'**
  String get detected_data;

  /// Confirmation message shown when OCR data is successfully detected.
  ///
  /// In pt, this message translates to:
  /// **'Dados detectados com sucesso!'**
  String get ocr_data_detected;

  /// Hint shown for optional fields.
  ///
  /// In pt, this message translates to:
  /// **'Opcional'**
  String get optional;

  /// Label shown for optional fields.
  ///
  /// In pt, this message translates to:
  /// **'Campos opcionais'**
  String get optional_fields;

  /// Label for card types screen.
  ///
  /// In pt, this message translates to:
  /// **'Brevemente'**
  String get coming_soon;

  /// Label for loyalty card.
  ///
  /// In pt, this message translates to:
  /// **'Fidelização'**
  String get loyalty_card;

  /// Label for SIM card.
  ///
  /// In pt, this message translates to:
  /// **'SIM'**
  String get sim_card;

  /// Label for business card.
  ///
  /// In pt, this message translates to:
  /// **'Visita'**
  String get business_card;

  /// Label for membership card.
  ///
  /// In pt, this message translates to:
  /// **'Sócio'**
  String get membership_card;

  /// Label for informative card.
  ///
  /// In pt, this message translates to:
  /// **'Informativo'**
  String get informative_card;

  /// Label for rewards card.
  ///
  /// In pt, this message translates to:
  /// **'Recompensas'**
  String get rewards_card;

  /// Label for others card.
  ///
  /// In pt, this message translates to:
  /// **'Outro'**
  String get other_card;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
