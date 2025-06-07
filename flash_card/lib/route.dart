/* Routes */
import 'package:flash_card/screens/views/error_screen.dart';
import 'package:flash_card/screens/views/favorites.dart';
import 'package:flash_card/screens/views/page_index.dart';
import 'package:flash_card/screens/views/settings.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/home':
      return MaterialPageRoute(builder: (_) => const PageIndex());
    case '/favorites':
      return MaterialPageRoute(builder: (_) => const FavoritesScreen());
    case '/settings':
      return MaterialPageRoute(builder: (_) => const SettingsScreen());
    default:
      return MaterialPageRoute(builder: (_) => const ErrorScreen());
  }
}
