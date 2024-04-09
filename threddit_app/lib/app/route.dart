import 'package:flutter/material.dart';
import 'package:threddit_clone/features/user_system/view/screens/confirm_password_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/settings_screen.dart';
import 'package:threddit_clone/models/post.dart';
import 'package:threddit_clone/features/community/view/community_screen.dart';
import 'package:threddit_clone/features/community/view/create_community.dart';
import 'package:threddit_clone/features/home_page/view/screens/add_post_screen.dart';
import 'package:threddit_clone/features/home_page/view/screens/chat_screen.dart';
import 'package:threddit_clone/features/home_page/view/screens/main_community_screen.dart';
import 'package:threddit_clone/features/home_page/view/screens/home_screen.dart';
import 'package:threddit_clone/features/home_page/view/screens/main_screen_layout.dart';
import 'package:threddit_clone/features/home_page/view/screens/notifications_screen.dart';
import 'package:threddit_clone/features/home_page/view/screens/search_screen.dart';
import 'package:threddit_clone/features/home_page/view/screens/user_profile_screen.dart';
import 'package:threddit_clone/features/post/view/post_to_screen.dart';
import 'package:threddit_clone/features/posting/data/data.dart';
import 'package:threddit_clone/features/posting/view/screens/post_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/about_you_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/account_settings_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/blocked_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/change_password_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/forget_send_mail.dart';
import 'package:threddit_clone/features/user_system/view/screens/forget_username.dart';
import 'package:threddit_clone/features/user_system/view/screens/notifications_settings_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/register_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/signup_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/update_email_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/username_screen.dart';
import 'package:threddit_clone/features/user_system/view_model/starting_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/interests_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/forget_password.dart';
import 'package:threddit_clone/models/post.dart';
import '../features/user_system/view/screens/login_screen.dart';

class RouteClass {
  static const String initRoute = "/";
  static const String loginScreen = "/login";
  static const String signUpScreen = "/signup";
  static const String registerScreen = "/register";
  static const String mainLayoutScreen = "/main";
  static const String communityScreen = "/community";
  static const String homeScreen = "/home";
  static const String appPostScreen = "/app_post_screen";
  static const String chatScreen = "/chat";
  static const String mainCommunityScreen = "/communities";
  static const String notificationsScreen = "/notifications";
  static const String notificationsSettingsScreen = "/notifications_settings";
  static const String postToScreen = "/post_to";
  static const String postScreen = "/post";
  static const String accountSettingsScreen = '/account_settings';
  static const String blockedScreen = '/block_screen';
  static const String changePasswordScreen = '/change_password';
  static const String updateEmailScreen = '/update_mail';
  static const String userProfileScreen = '/my_profile';
  static const String searchScreen = '/search';
  static const String createCommunityScreen = '/create_community';
  static const String accountSettingScreen = '/account_Settings';
  static const String userNameScreen = '/loading';
  static const String aboutMeScreen = '/aboutme';
  static const String interestsScreen = '/interests';
  static const String forgetPasswordScreen = '/forget_password';
  static const String forgetUsernameScreen = '/forget_username';
  static const String forgetRdirectScreen = '/forget_redirect';
  static const String confirmPasswordScreen = "/confirm-password";
  static const String settingsScreen = "/settings";

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
        return MaterialPageRoute(builder: (_) => const StartScreen());
      case userProfileScreen:
        return MaterialPageRoute(builder: (_) => const UserProfile());
      case accountSettingScreen:
        return MaterialPageRoute(builder: (_) => const AccountSettingsScreen());
      case searchScreen:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => const LogInScreen());
      case signUpScreen:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case registerScreen:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case appPostScreen:
        return MaterialPageRoute(builder: (_) => const AddPostScreen());
      case chatScreen:
        return MaterialPageRoute(builder: (_) => const ChatScreen());
      case mainCommunityScreen:
        return MaterialPageRoute(builder: (_) => const MainCommunityScreen());
      case notificationsScreen:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case notificationsSettingsScreen:
        return MaterialPageRoute(
            builder: (_) =>  NotificationsSettingsScreen());
      case postToScreen:
        return MaterialPageRoute(builder: (_) => const PostToScreen());
      case accountSettingsScreen:
        return MaterialPageRoute(builder: (_) => const AccountSettingsScreen());
      case blockedScreen:
        return MaterialPageRoute(builder: (_) => const BlockedScreen());
      case changePasswordScreen:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      case userNameScreen:
        return MaterialPageRoute(builder: (_) => const UserName());
      case updateEmailScreen:
        return MaterialPageRoute(builder: (_) => const UpdateEmailScreen());
      case aboutMeScreen:
        return MaterialPageRoute(builder: (_) => const AboutYou());
      case interestsScreen:
        return MaterialPageRoute(builder: (_) => const Interests());
      case forgetPasswordScreen:
        return MaterialPageRoute(builder: (_) => const ForgetPassword());
      case forgetUsernameScreen:
        return MaterialPageRoute(builder: (_) => const ForgetUsername());
      case forgetRdirectScreen:
        return MaterialPageRoute(builder: (_) => const ForgetSentMail());
      case mainLayoutScreen:
        return MaterialPageRoute(builder: (_) => const MainScreenLayout());
        case confirmPasswordScreen:
        return MaterialPageRoute(builder: (_) => const ConfirmPasswordScreen());
        case settingsScreen:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case communityScreen:
        List<String> input = settings.arguments as List<String>;
        print(input);
        return MaterialPageRoute(
            builder: (_) => CommunityScreen(
                  id: input[0],
                  uid: input[1],
                ));
      case postScreen:
        Post data = settings.arguments as Post;
        return MaterialPageRoute(
            builder: (_) => PostScreen(
                  currentPost: data,
                ));
      case createCommunityScreen:
        //var data = settings.arguments as String;
        var data = 'User2';
        return MaterialPageRoute(
            builder: (_) => CreateCommunity(
                  uid: data,
                ));
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
