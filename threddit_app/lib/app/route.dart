import 'package:flutter/material.dart';
import 'package:threddit_clone/features/Moderation/view/screens/community_mod_tools.dart';
import 'package:threddit_clone/features/community/view/community_info.dart';
import 'package:threddit_clone/features/post/view/cross_post.dart';
import 'package:threddit_clone/features/user_profile/view/user_profile_screen.dart';
import 'package:threddit_clone/features/Moderation/view/screens/approve_screen.dart';
import 'package:threddit_clone/features/Moderation/view/screens/approved_users_screen.dart';
import 'package:threddit_clone/features/Moderation/view/screens/ban_screen.dart';
import 'package:threddit_clone/features/Moderation/view/screens/banned_users_screen.dart';
import 'package:threddit_clone/features/Moderation/view/screens/update_ban_screen.dart';
import 'package:threddit_clone/features/Moderation/view/screens/update_ban_screen.dart';
import 'package:threddit_clone/features/community/view/community_info.dart';
import 'package:threddit_clone/features/user_system/view/screens/block_user_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/confirm_password_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/forgot_password.dart';
import 'package:threddit_clone/models/subreddit.dart';
import 'package:threddit_clone/features/user_system/view/screens/settings_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/text_size_screen.dart';
import 'package:threddit_clone/models/post.dart';
import 'package:threddit_clone/features/community/view/community_screen.dart';
import 'package:threddit_clone/features/community/view/create_community.dart';
import 'package:threddit_clone/features/home_page/view/screens/chat_screen.dart';
import 'package:threddit_clone/features/home_page/view/screens/main_community_screen.dart';
import 'package:threddit_clone/features/home_page/view/screens/home_screen.dart';
import 'package:threddit_clone/features/home_page/view/screens/main_screen_layout.dart';
import 'package:threddit_clone/features/home_page/view/screens/notifications_screen.dart';
import 'package:threddit_clone/features/home_page/view/screens/search_screen.dart';
import 'package:threddit_clone/features/post/view/add_post_screen.dart';
import 'package:threddit_clone/features/post/view/confirm_post.dart';
import 'package:threddit_clone/features/post/view/post_to_screen.dart';
import 'package:threddit_clone/features/posting/view/screens/post_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/about_you_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/account_settings_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/blocked_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/change_password_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/forgot_send_mail.dart';
import 'package:threddit_clone/features/user_system/view/screens/forgot_username.dart';
import 'package:threddit_clone/features/user_system/view/screens/notifications_settings_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/register_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/signup_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/update_email_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/username_screen.dart';
import 'package:threddit_clone/features/user_system/view_model/starting_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/interests_screen.dart';
import 'package:threddit_clone/features/user_system/view/screens/login_screen.dart';
import 'package:threddit_clone/features/post/view/choose_community.dart';

import '../features/user_system/view/screens/login_screen.dart';
// import 'package:threddit_clone/models/post.dart';

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
  static const String forgotPasswordScreen = '/forgot_password';
  static const String forgotUsernameScreen = '/forgot_username';
  static const String forgotRdirectScreen = '/forgot_redirect';
  static const String confirmPasswordScreen = "/confirm-password";
  static const String confirmPostScreen = '/confirmpost';
  static const String communityModTools = '/communitymodtools';
  static const String communityInfo = '/communityinfo';
  static const String chooseCommunity = '/choose_communtiy';
  static const String crossPost = '/cross_post';
  static const String settingsScreen = "/settings";
  static const String textSize = '/text-size';
  static const String bannedUsersScreen = '/banned-users';
  static const String banScreen = '/ban';
  static const String updateBanScreen = '/update-ban';
  static const String approvedUsersScreen = '/approved-users';
  static const String approveScreen = '/approve';
  static const String blockUserScreen = '/block-user';

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
      // case userProfileScreen:
      //   return MaterialPageRoute(builder: (_) => const UserProfile());
      case accountSettingScreen:
        return MaterialPageRoute(builder: (_) => const AccountSettingsScreen());
      case searchScreen:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case communityInfo:
        final args = settings.arguments as Map<String, dynamic>;
        final community =
            args['community'] as Subreddit; // Extract the community object
        final uid = args['uid'] as String;
        return MaterialPageRoute(
            builder: (_) => CommunityInfo(community: community, uid: uid));

      case communityModTools:
        return MaterialPageRoute(builder: (_) => const CommunityModTools());
      case chooseCommunity:
        return MaterialPageRoute(builder: (_) => const ChooseCommunity());
      case crossPost:
        return MaterialPageRoute(builder: (_) => const CrossPost());
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
        return MaterialPageRoute(builder: (_) => NotificationsSettingsScreen());
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
      case forgotPasswordScreen:
        return MaterialPageRoute(builder: (_) => const ForgotPassword());
      case forgotUsernameScreen:
        return MaterialPageRoute(builder: (_) => const ForgotUsername());
      case forgotRdirectScreen:
        return MaterialPageRoute(builder: (_) => const ForgotSentMail());
      case mainLayoutScreen:
        return MaterialPageRoute(builder: (_) => const MainScreenLayout());
      case confirmPasswordScreen:
        return MaterialPageRoute(builder: (_) => const ConfirmPasswordScreen());
      case settingsScreen:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case blockUserScreen:
        return MaterialPageRoute(
            builder: (_) => const BlockUserScreen(), fullscreenDialog: true);
      case blockedScreen:
        return MaterialPageRoute(builder: (_) => const BlockedScreen());
      case communityModTools:
        return MaterialPageRoute(builder: (_) => const CommunityModTools());
      case textSize:
        return MaterialPageRoute(builder: (_) => TextSizeScreen());
      case bannedUsersScreen:
        return MaterialPageRoute(builder: (_) => const BannedUsersScreen());
      case banScreen:
        return MaterialPageRoute(
            builder: (_) => const BanScreen(), fullscreenDialog: true);

      case approvedUsersScreen:
        return MaterialPageRoute(builder: (_) => const ApprovedUsersScreen());
      case approveScreen:
        return MaterialPageRoute(
            builder: (_) => const ApproveScreen(), fullscreenDialog: true);

      case updateBanScreen:
        List<String> input = settings.arguments as List<String>;
        return MaterialPageRoute(
            builder: (_) => UpdateBanScreen(user: input[0], reason: input[1]),
            fullscreenDialog: true);
      case communityInfo:
        final args = settings.arguments as Map<String, dynamic>;
        final community =
            args['community'] as Subreddit; // Extract the community object
        final uid = args['uid'] as String;
        return MaterialPageRoute(
            builder: (_) => CommunityInfo(community: community, uid: uid));
      case communityScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final id = args['id'] as String; // Extract the community object
        final uid = args['uid'] as String;
        return MaterialPageRoute(
          builder: (_) => CommunityScreen(
            id: id,
            uid: uid,
          ),
        );
      case confirmPostScreen:
        return MaterialPageRoute(builder: (_) => const ConfirmPost());
      case postScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final currentpost =
            args['currentpost'] as Post; // Extract the community object
        final uid = args['uid'] as String;
        return MaterialPageRoute(
            builder: (_) => PostScreen(
                  currentPost: currentpost,
                  uid: uid,
                ));
      case createCommunityScreen:
        //var data = settings.arguments as String;
        var data = 'User2';
        return MaterialPageRoute(
          builder: (_) => CreateCommunity(
            uid: data,
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
