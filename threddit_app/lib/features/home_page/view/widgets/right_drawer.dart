import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/view/widgets/right_drawer_buttons.dart';
import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/google_auth_controller.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/photos.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class RightDrawer extends ConsumerWidget{
  const RightDrawer({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  Drawer(
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
                      child: Image.asset(
                        Photos.snoLogo,
                        width: 50.w,
                        height: 50.h,
                      ),
                    ),
                    Text(
                      'u/UserName',
                      style: AppTextStyles.primaryTextStyle,
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
                      context, RouteClass.createCommunityScreen);
                }),
            RightDrawerButtons(
                icon: const Icon(
                  Icons.bookmarks_outlined,
                  color: AppColors.whiteColor,
                ),
                title: "Saved",
                onTap: () {}),
            RightDrawerButtons(
                icon: const Icon(
                  Icons.history_toggle_off_rounded,
                  color: AppColors.whiteColor,
                ),
                title: "History",
                onTap: () {}),
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
                  
                  Navigator.pushNamed(context, RouteClass.communityModTools);
                }),
          ],
        ),
      );
  }
}