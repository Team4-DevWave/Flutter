import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/features/user_system/view/screens/login_screen.dart';
import 'package:threddit_app/features/user_system/view/screens/signup_screen.dart';
import 'package:threddit_app/features/user_system/view/widgets/app_agreement.dart';
import 'package:threddit_app/features/user_system/view/widgets/continue_with_google.dart';
import 'package:threddit_app/theme/button_styles.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/photos.dart';
import 'package:threddit_app/theme/text_styles.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            Photos.snoLogo,
            width: 40.w,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => const LogInScreen(),
                ),
              );
            },
            child: Text(
              'Log in',
              style: AppTextStyles.primaryTextStyle,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(children: [
              SizedBox(height: 20.h),
              Text(
                'Hi new friend, welcome to Reddit',
                style: AppTextStyles.primaryTextStyle
                    .copyWith(fontSize: 25.sp, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25.h),
              const ContinueWithGoogle(),
              SizedBox(height: 15.h),
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      color: AppColors.whiteColor,
                      height: 1,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.w),
                    child: Text(
                      'OR',
                      style: AppTextStyles.primaryTextStyle,
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      color: AppColors.whiteColor,
                      height: 1,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
            ]),
            Container(
              margin: EdgeInsets.only(bottom: 15.h),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const AppAgreement(),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: AppButtons.registerButtons,
                    child: Text('Continue',
                        style: AppTextStyles.primaryTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
