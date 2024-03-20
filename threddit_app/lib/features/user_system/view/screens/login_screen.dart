import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/app/route.dart';
import 'package:threddit_app/features/user_system/view/widgets/app_agreement.dart';
import 'package:threddit_app/features/user_system/view/widgets/continue_with_google.dart';
import 'package:threddit_app/features/user_system/view/widgets/text_form.dart';
import 'package:threddit_app/theme/button_styles.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/photos.dart';
import 'package:threddit_app/theme/text_styles.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            Photos.snoLogo,
            width: 40.w,
            height: 40.h,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteClass.signUpScreen);
            },
            child: Text(
              'Sign up',
              style: AppTextStyles.primaryTextStyle,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 13.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    'Log in to Reddit',
                    style: AppTextStyles.primaryTextStyle.copyWith(
                        fontSize: 28.spMin, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 25.h),
                  const ContinueWithGoogle(),
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.whiteColor,
                          height: 1.h,
                          thickness: 1.h,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13.w),
                        child: Text(
                          'OR',
                          style: AppTextStyles.primaryTextStyle,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.whiteColor,
                          height: 1.h,
                          thickness: 1.w,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 13.h),
                  const TextForm(identifier: 'login'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forget password?',
                            style: AppTextStyles.primaryTextStyle.copyWith(
                              color: AppColors.redditOrangeColor,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                    ],
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(bottom: 15.h),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const AppAgreement(),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: () {
                        //must changed
                        Navigator.popAndPushNamed(
                            context, RouteClass.mainScreen);
                      },
                      style: AppButtons.registerButtons,
                      child: Text('Continue',
                          style: AppTextStyles.primaryTextStyle.copyWith(
                            fontSize: 16.spMin,
                            fontWeight: FontWeight.w600,
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
