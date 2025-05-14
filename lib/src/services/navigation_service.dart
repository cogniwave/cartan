import 'package:flutter/material.dart';

class NavigationService {
  // Singleton pattern
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  // Global key for accessing Navigator state
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Navigation methods
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed<T>(routeName, arguments: arguments);
  }

  Future<T?> push<T>(Route<T> route) {
    return navigatorKey.currentState!.push(route);
  }

  void pop<T>([T? result]) {
    navigatorKey.currentState!.pop(result);
  }

  Future<T?> pushReplacement<T, TO>(Route<T> route, {TO? result}) {
    return navigatorKey.currentState!.pushReplacement(route, result: result);
  }
}