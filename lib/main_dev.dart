import 'utils/flavor_config.dart';
import 'main.dart';

void main() async {
  FlavorConfig(
    flavor: Flavor.dev,
    values: FlavorValues(
      apiBaseUrl: "https://apibaseurl-dev.com",
      appIcon: "assets/images/icon/app_icon_white.png",
      appName: "Cartan - Dev",
    ),
  );

  // Call main method
  initializeApp();
}