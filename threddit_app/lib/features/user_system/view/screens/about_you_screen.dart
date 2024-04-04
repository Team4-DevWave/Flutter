import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/view/widgets/register_appbar.dart';
import 'package:threddit_clone/features/user_system/view_model/user_system_providers.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class AboutYou extends ConsumerWidget {
  const AboutYou({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: RegisterAppBar(
          action: () {
            Navigator.pushNamed(context, RouteClass.userNameScreen);
          },
          title: 'Skip'),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.h),
        height: MediaQuery.of(context).size.height.h,
        width: MediaQuery.of(context).size.width.w,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          'About you',
                          style: AppTextStyles.primaryTextStyle.copyWith(
                            fontSize: 28.spMin,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          """
Tell us about yourself to improve your recommendations and ads""",
                          style: AppTextStyles.primaryTextStyle.copyWith(
                            fontSize: 20.spMin,
                            color: AppColors.whiteHideColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'How do you identify?',
                          style: AppTextStyles.primaryTextStyle.copyWith(
                            fontSize: 20.spMin,
                            color: AppColors.whiteHideColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 13.h),
                        Text(
                          user.email,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          user.username,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          user.password,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          user.token,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          user.isGoogle.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          user.country,
                          style: const TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
