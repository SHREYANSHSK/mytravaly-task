import 'package:flutter/material.dart';
import 'package:mytravaly_task/routes/app_routes_name.dart';
import '../presentation/auth/pages/google_sign_in_page.dart';
import '../presentation/home/pages/home_page.dart';
import '../presentation/search/pages/search_results_page.dart';

class AppRoutes {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutesName.signIn:
        return MaterialPageRoute(builder: (_) => const GoogleSignInPage());
      case AppRoutesName.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutesName.searchResults:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SearchResultsPage(
            query: args['query'] as String,
            searchType: args['searchType'] as String? ?? 'hotelIdSearch',
            displayText: args['displayText'] as String? ?? '',
          ),
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
