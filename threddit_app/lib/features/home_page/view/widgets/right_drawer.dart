import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/view/screens/saved_screen.dart';
import 'package:threddit_clone/features/home_page/view/widgets/following_tiles.dart';
import 'package:threddit_clone/features/home_page/view/widgets/right_drawer_buttons.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/google_auth_controller.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// A drawer widget providing user-specific actions and navigation options.
///
/// This drawer displays a header with the user's profile picture and username,
/// followed by buttons that allow the user to:
/// - View their profile ([userProfileScreen]).
/// - Create a community ([createCommunityScreen]).
/// - View their saved posts and comments ([SavedScreen]).
/// - View their history ([historyScreen]).
/// - Log out of the application.
/// - Go to settings ([settingsScreen]).
///
/// The drawer fetches the user's data from the `userModelProvider`
/// to display their profile information. 

class RightDrawer extends ConsumerStatefulWidget {
  const RightDrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RightDrawerState();
}

class _RightDrawerState extends ConsumerState<RightDrawer> {
  UserModelMe? user;
  void _getUserData() async {
    user = ref.read(userModelProvider)!;
  }

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _getUserData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      backgroundColor: AppColors.backgroundColor,
      shadowColor: AppColors.backgroundColor,
      surfaceTintColor: AppColors.backgroundColor,
      child: Column(
        children: [
          SizedBox(
            height: 150.h,
            child: DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, RouteClass.userProfileScreen);
                      },
                      child: CircleAvatar(
                        backgroundImage: putUserProfilepic(user!.profilePicture!),
                        radius: 30.spMin,
                      )),
                  SizedBox(height: 10.h),
                  Text(
                    'u/${user?.username}',
                    style: AppTextStyles.primaryTextStyle
                        .copyWith(fontSize: 17.spMin),
                  ),
                ],
              ),
            ),
          ),
          RightDrawerButtons(
              icon: const Icon(
                Icons.person_outline,
                color: AppColors.whiteColor,
              ),
              title: "My profile",
              onTap: () {
                Navigator.pop(context);

                Navigator.pushNamed(context, RouteClass.userProfileScreen);
              }),
          RightDrawerButtons(
              icon: const Icon(
                Icons.group_add_outlined,
                color: AppColors.whiteColor,
              ),
              title: "Create a community",
              onTap: () {
                Navigator.pop(context);

                Navigator.pushNamed(
                  context,
                  RouteClass.createCommunityScreen,
                  arguments: user?.id,
                );
              }),
          RightDrawerButtons(
              icon: const Icon(
                Icons.bookmarks_outlined,
                color: AppColors.whiteColor,
              ),
              title: "Saved",
              onTap: () {
                Navigator.pop(context);

                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SavedScreen()));
              }),
          RightDrawerButtons(
              icon: const Icon(
                Icons.history_toggle_off_rounded,
                color: AppColors.whiteColor,
              ),
              title: "History",
              onTap: () {
                Navigator.pop(context);

                Navigator.pushNamed(context, RouteClass.historyScreen,
                    arguments: "user2");
              }),
          RightDrawerButtons(
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.whiteColor,
            ),
            title: "Logout",
            onTap: () async {
              final response =
                  await ref.watch(authControllerProvider.notifier).logout();
              response.fold(
                  (failure) => showSnackBar(
                      navigatorKey.currentContext!, failure.message),
                  (success) async {
                await deleteAll();
                Navigator.pushReplacementNamed(
                    navigatorKey.currentContext!, RouteClass.registerScreen);
                showSnackBar(navigatorKey.currentContext!,
                    "Heyy ${ref.read(userModelProvider)?.username}, can't wait to see you again!");
              });
            },
          ),
          RightDrawerButtons(
              icon: const Icon(
                Icons.settings_outlined,
                color: AppColors.whiteColor,
              ),
              title: "Settings",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, RouteClass.settingsScreen);
              }),
        ],
      ),
    );
  }
}
