import 'utils/flavor_config.dart';
import 'main.dart';

void main() async {
  FlavorConfig(
    flavor: Flavor.staging,
    values: FlavorValues(
      apiBaseUrl: "https://apibaseurl-staging.com",
      appIcon: "assets/images/icon/app_icon_white.png",
      appName: "Cartan - Staging",
    ),
  );

  // Call main method
  initializeApp();
}