import 'package:flutter/material.dart';
import '../presentation/auth/pages/google_sign_in_page.dart';
import '../presentation/home/pages/home_page.dart';
import '../presentation/search/pages/search_results_page.dart';

class AppRoutes {
  static const String signIn = '/';
  static const String home = '/home';
  static const String searchResults = '/search-results';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signIn:
        return MaterialPageRoute(builder: (_) => const GoogleSignInPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case searchResults:
        final query = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => SearchResultsPage(query: query),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
