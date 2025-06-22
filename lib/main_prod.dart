import 'main.dart';
import 'utils/flavor_config.dart';

void main() async {
  FlavorConfig(
    flavor: Flavor.prod,
    values: FlavorValues(
      apiBaseUrl: "https://apibaseurl-prod.com",
      appIcon: "assets/images/icon/app_icon_white.png",
      appName: "Cartan",
    ),
  );

  // Call main method
  initializeApp();
}