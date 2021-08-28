import 'package:flutter/material.dart';
import '../screens/screens.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print("Route: ${settings.name}");
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          settings: const RouteSettings(name: "/"),
          builder: (_) => Scaffold(),
        );
      case Wrapper.routeName:
        return Wrapper.route();
      default:
        return _errorRoute();
    }
  }

  static MaterialPageRoute _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
      ),
    );
  }
}
