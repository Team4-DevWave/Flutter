import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/user_system/view/widgets/app_agreement.dart';
import 'package:threddit_clone/features/user_system/view/widgets/continue_with_email.dart';
import 'package:threddit_clone/features/user_system/view/widgets/continue_with_google.dart';
import 'package:threddit_clone/features/user_system/view_model/navigate_register_login.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/photos.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///This screen is considered as the first screen in the registration process
///it contains welcome message and two buttons; the continue with email button and
///the continue with gooogle button.
///
///Continue with email button: pushes the Sign up screen
///
///Google sign in button: opens the google pop up window to choose the user google account
///and then validate with the backend if the user exist or new one
class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.h),
        height: MediaQuery.of(context).size.height.h,
        width: MediaQuery.of(context).size.width.w,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: ScreenUtil().statusBarHeight.h),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Photos.snoLogo,
                    width: 55.w,
                    height: 55.h,
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Text(
                      'All your interests in one place',
                      style: AppTextStyles.welcomeScreen,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const ContinueWithGoogle(),
                  SizedBox(height: 10.h),
                  const ContinueWithEmail(),
                  SizedBox(height: 16.h),
                  const AppAgreement(),
                  SizedBox(height: 15.h),
                  TextButton(
                    onPressed: () => ref.read(navgationRegisterLogin)(context),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Already a redditor? ',
                            style: AppTextStyles.primaryTextStyle.copyWith(
                              fontSize: 14.spMin,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: 'Log in',
                            style: AppTextStyles.primaryTextStyle.copyWith(
                                fontSize: 14.spMin,
                                fontWeight: FontWeight.w600,
                                color: AppColors.redditOrangeColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
