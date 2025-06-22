// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'Cartan';

  @override
  String get cards => 'Cards';

  @override
  String get empty_cards => 'You don\'t have any cards linked yet';

  @override
  String get add => 'Add';

  @override
  String get help => 'Help';

  @override
  String get settings => 'Settings';

  @override
  String get success => 'Operation completed successfully!';

  @override
  String get error => 'An error occurred while processing your request.';

  @override
  String get close => 'Close';

  @override
  String get language => 'Language';

  @override
  String get dark_mode => 'Dark mode';

  @override
  String get font_size => 'Font size';

  @override
  String get terms_and_conditions => 'Terms and conditions';

  @override
  String get terms_and_conditions_url =>
      'https://firebasestorage.googleapis.com/v0/b/cartan-a6680.firebasestorage.app/o/en%2Fterms_conditions.html?alt=media';

  @override
  String get privacy_policy => 'Privacy Policy';

  @override
  String get privacy_policy_url =>
      'https://firebasestorage.googleapis.com/v0/b/cartan-a6680.firebasestorage.app/o/en%2Fprivacy_policy.html?alt=media';

  @override
  String get feedback => 'Feedback';

  @override
  String get large_font => 'Large';

  @override
  String get normal_font => 'Normal';

  @override
  String get small_font => 'Small';

  @override
  String get select_merchant => 'Select merchant';

  @override
  String get scan_barcode => 'Scan barcode';

  @override
  String get enter_manually => 'Enter manually';

  @override
  String get position_barcode_in_frame =>
      'Position the barcode within the frame';

  @override
  String get scanning_hint =>
      'Make sure the barcode is well-lit and clearly visible';

  @override
  String get card_number => 'Card number';

  @override
  String get add_card => 'Add card';

  @override
  String get format_hint => 'Enter the number shown on your loyalty card';

  @override
  String get invalid_card_format => 'Invalid card format';

  @override
  String get card_added_successfully => 'Card added successfully';

  @override
  String get barcode => 'Barcode';

  @override
  String get qr_code => 'QR Code';

  @override
  String get zoom => 'Zoom';

  @override
  String get back => 'Back';

  @override
  String get nearest_places => 'Nearest places';

  @override
  String get website => 'Website';

  @override
  String get remove => 'Remove';

  @override
  String get confirm_delete => 'Delete card';

  @override
  String get confirm_delete_message =>
      'Are you sure you want to remove this card? This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get card_deleted_successfully => 'Card deleted successfully.';

  @override
  String get error_deleting_card =>
      'An error occurred while deleting the card.';

  @override
  String get no_map_apps_installed => 'No map apps installed';

  @override
  String get search => 'Search';

  @override
  String get camera_permission_required =>
      'Camera access is required to scan your card.';

  @override
  String get open_settings => 'Open App Settings';

  @override
  String get digits => 'digits';

  @override
  String get name => 'Name';

  @override
  String get email => 'Email';

  @override
  String get message => 'Message';

  @override
  String get submit => 'Submit feedback';

  @override
  String get feedback_sent => 'Thank you for your feedback!';

  @override
  String get name_required => 'Name is required.';

  @override
  String get email_required => 'Email is required.';

  @override
  String get invalid_email => 'Please enter a valid email address.';

  @override
  String get message_required => 'Please enter your feedback.';

  @override
  String get feedback_submission_error =>
      'Failed to send feedback. Please try again later.';

  @override
  String get card_already_exists =>
      'A card for this merchant with that number already exists.';

  @override
  String get no_results_found => 'No results found';

  @override
  String get invalid_card_not_empty_alphanumeric =>
      'Card number must be alphanumeric and not empty.';
}
