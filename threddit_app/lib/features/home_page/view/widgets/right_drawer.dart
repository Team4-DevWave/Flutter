import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/view/screens/saved_screen.dart';
import 'package:threddit_clone/features/home_page/view/widgets/right_drawer_buttons.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/google_auth_controller.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

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
  Widget build(BuildContext context) {

    

    ImageProvider setProfilePic() {
      if (user!.profilePicture != "") {
        return NetworkImage(user!.profilePicture!);
      } else {
        return const AssetImage('assets/images/Default_Avatar.png');
      }
    }

    return Drawer(
      backgroundColor: AppColors.mainColor,
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
                      Navigator.pushNamed(
                          context, RouteClass.userProfileScreen);
                    },
                    child: CircleAvatar(backgroundImage: setProfilePic(), radius: 30.spMin,)
                  ),
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
                Navigator.pushNamed(context, RouteClass.userProfileScreen);
              }),
          RightDrawerButtons(
              icon: const Icon(
                Icons.group_add_outlined,
                color: AppColors.whiteColor,
              ),
              title: "Create a community",
              onTap: () {
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
                Navigator.pushNamed(context, RouteClass.historyScreen,
                    arguments: "user2");
              }),
          RightDrawerButtons(
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.whiteColor,
            ),
            title: "Logout",
            onTap: () => ref.watch(authControllerProvider.notifier).logout(),
          ),
          RightDrawerButtons(
              icon: const Icon(
                Icons.settings_outlined,
                color: AppColors.whiteColor,
              ),
              title: "Settings",
              onTap: () {
                Navigator.pushNamed(context, RouteClass.settingsScreen);
              }),
        ],
      ),
    );
  }
}
