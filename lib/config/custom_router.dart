import 'package:flutter/material.dart';
import '../screens/screens.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) {
        print("Route: ${settings.name}");
        switch (settings.name) {
          case "/":
            return const Scaffold();
          case Wrapper.routeName:
            return const Wrapper();
          case VerificationPage.routeName:
            return VerificationPage();
          case NavScreen.routeName:
            return NavScreen();
          default:
            return _errorRoute();
        }
      },
    );
  }

  static Route onGenerateNestedRoute(RouteSettings routeSettings) {
    print("Nested Route: ${routeSettings.name}");
    return MaterialPageRoute<void>(
      settings: routeSettings,
      builder: (_) {
        switch (routeSettings.name) {
          default:
            return _errorRoute();
        }
      },
    );
  }

  static Scaffold _errorRoute() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.error_outline, size: 40),
              SizedBox(height: 13),
              Text(
                "Something went wrong",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "we can not find the route you are asking for. Something went wrong...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
