import 'utils/flavor_config.dart';
import 'main.dart';

void main() async {
  FlavorConfig(
    flavor: Flavor.staging,
    values: FlavorValues(
      apiBaseUrl: "https://apibaseurl-staging.com",
      appIcon: "assets/images/app_icon_staging.png",
      appName: "App Staging",
    ),
  );

  // Call main method
  initializeApp();
}