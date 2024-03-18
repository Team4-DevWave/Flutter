import 'package:flutter/material.dart';
import 'package:threddit_app/features/home_page/view/screens/add_post_screen.dart';
import 'package:threddit_app/features/home_page/view/screens/chat_screen.dart';
import 'package:threddit_app/features/home_page/view/screens/community_screen.dart';
import 'package:threddit_app/features/home_page/view/screens/home_screen.dart';
import 'package:threddit_app/features/home_page/view/screens/main_screen_layout.dart';
import 'package:threddit_app/features/home_page/view/screens/notifications_screen.dart';
import 'package:threddit_app/features/home_page/view/screens/post_to_screen.dart';
import 'package:threddit_app/features/user_system/view/screens/account_settings_screen.dart';
import 'package:threddit_app/features/user_system/view/screens/blocked_screen.dart';
import 'package:threddit_app/features/user_system/view/screens/change_password_screen.dart';
import 'package:threddit_app/features/user_system/view/screens/notifications_settings_screen.dart';
import 'package:threddit_app/features/user_system/view/screens/register_screen.dart';
import 'package:threddit_app/features/user_system/view/screens/signup_screen.dart';
import 'package:threddit_app/features/user_system/view/screens/update_email_screen.dart';

import '../features/user_system/view/screens/login_screen.dart';

class RouteClass {
  static const String initRoute = "/";
  static const String loginScreen = "/login";
  static const String signUpScreen = "/signup";
  static const String registerScreen = "/register";
  static const String homeScreen = "/home";
  static const String mainScreen = "/main";
  static const String appPostScreen = "/app_post_screen";
  static const String chatScreen = "/chat";
  static const String communityScreen = "/community";
  static const String notificationsScreen = "/notifications";
  static const String notificationsSettingsScreen = "/notifications_settings";
  static const String postToScreen = "/post_to";
  static const String postScreen = "/post";
  static const String accountSettingsScreen = '/account_settings';
  static const String blockedScreen = '/block_screen';
  static const String changePasswordScreen = '/change_password';
  static const String updateEmailScreen = '/update_mail';

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
      case mainScreen:
        return MaterialPageRoute(builder: (_) => const MainScreenLayout());
      case appPostScreen:
        return MaterialPageRoute(builder: (_) => const AddPostScreen());
      case chatScreen:
        return MaterialPageRoute(builder: (_) => const ChatScreen());
      case communityScreen:
        return MaterialPageRoute(builder: (_) => const CommunityScreen());
      case notificationsScreen:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case notificationsSettingsScreen:
        return MaterialPageRoute(
            builder: (_) => const NotificationsSettingsScreen());
      case postToScreen:
        return MaterialPageRoute(builder: (_) => const PostToScreen());
      case accountSettingsScreen:
        return MaterialPageRoute(builder: (_) => const AccountSettingsScreen());
      case blockedScreen:
        return MaterialPageRoute(builder: (_) => const BlockedScreen());
      case changePasswordScreen:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      case updateEmailScreen:
        return MaterialPageRoute(builder: (_) => const UpdateEmailScreen());
      case postScreen:
      //return MaterialPageRoute(builder: (_) => const PostScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
