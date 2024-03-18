import 'package:flutter/material.dart';
import 'package:threddit_app/features/home_page/view/screens/home_screen.dart';
import 'package:threddit_app/features/user_system/view/screens/register_screen.dart';
import 'package:threddit_app/features/user_system/view/screens/signup_screen.dart';

import '../features/user_system/view/screens/login_screen.dart';

class RouteClass {
  static const String initRoute = "/";
  static const String loginScreen = "/login";
  static const String signUpScreen = "/signup";
  static const String registerScreen = "/register";
  static const String homeScreen = "/home";

  /// Generates the appropriate route based on the provided [settings].
  ///
  /// The [settings] parameter contains the name of the route and optional arguments.
  /// The method uses a switch statement to match the route name and returns the corresponding [Route].
  /// If no matching route is found, a default route is returned with a centered text widget displaying an error message.
  ///
  /// Example usage:
  /// ```dart
  /// Route<dynamic> route = generateRoute(RouteSettings(name: 'homeScreen'));
  /// Navigator.push(context, route);
  /// ```
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => const LogInScreen());
      case signUpScreen:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case registerScreen:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
