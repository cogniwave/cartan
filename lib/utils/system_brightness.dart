import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

class SystemBrightness {
  static Future<double> get brightness async {
    try {
      return await ScreenBrightness().application;
    } catch (e) {
      debugPrint('Failed to get brightness: $e');
      return 0.5; // Default fallback
    }
  }

  static Future<void> setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setApplicationScreenBrightness(brightness);
    } catch (e) {
      debugPrint('Failed to set brightness: $e');
    }
  }
}