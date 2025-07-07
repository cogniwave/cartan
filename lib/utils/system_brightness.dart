import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';

class SystemBrightness {
  static Future<double> get brightness async {
    try {
      return await ScreenBrightness().application;
    } catch (e) {
      bugsnag.notify(e, StackTrace.current);
      return 0.5; // Default fallback
    }
  }

  static Future<void> setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setApplicationScreenBrightness(brightness);
    } catch (e) {
      bugsnag.notify(e, StackTrace.current);
    }
  }
}
