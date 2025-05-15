import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cartan/src/services/scaffold_messenger_service.dart';
import 'package:cartan/src/themes/app_themes.dart';

class AppSnackBar {
  // Success message
  static void showSuccess(String message) {
    final service = ScaffoldMessengerService();
    final theme = service.theme;
    final customColors = theme.extension<CustomColors>()!;

    service.showMessage(
      message: message,
      color: customColors.success,
      icon: AntIcons.checkOutlined,
      actionLabel: 'OK',
    );
  }

  // Error message
  static void showError(String message) {
    final service = ScaffoldMessengerService();
    final theme = service.theme;
    final localizations = service.localizations;

    service.showMessage(
      message: message,
      color: theme.colorScheme.error,
      icon: AntIcons.closeOutlined,
      actionLabel: localizations.close,
      duration: const Duration(seconds: 4),
    );
  }
}