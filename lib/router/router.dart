// lib/router/router.dart
import 'package:flutter/material.dart';
import '../pages/chat.dart';
import '../pages/settings/settings.dart';
import '../pages/settings/provider.dart';

class AppRouter {
  static const String chatPage = '/';
  static const String settingsPage = '/settings';
  static const String providerPage = '/settings/provider';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case chatPage:
        return MaterialPageRoute(builder: (_) => ChatPage());
      case settingsPage:
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case providerPage:
        return MaterialPageRoute(builder: (_) => ProviderPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
