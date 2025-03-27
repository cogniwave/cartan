import 'utils/flavor_config.dart';
import 'main.dart';

void main() async {
  FlavorConfig(
    flavor: Flavor.dev,
    values: FlavorValues(
      apiBaseUrl: "https://apibaseurl-dev.com",
      appIcon: "assets/images/app_icon_dev.png",
      appName: "App Dev",
    ),
  );

  // Call main method
  initializeApp();
}