import 'package:flutter/material.dart';
import 'package:threddit_app/features/user_system/view/screens/login_screen.dart';
import 'package:threddit_app/features/user_system/view/widgets/app_agreement.dart';
import 'package:threddit_app/features/user_system/view/widgets/register_buttons.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/photos.dart';
import 'package:threddit_app/theme/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var screenHeight = ScreenUtil().screenHeight;

  void _login(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LogInScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      screenHeight = ScreenUtil().screenHeight;
    });
    return Scaffold(
      body: SizedBox(
        height: screenHeight,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: ScreenUtil().statusBarHeight),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
              Container(
                margin: EdgeInsets.only(bottom: 10.h, left: 13.w, right: 13.w),
                child: Column(
                  children: [
                    const RegisterButtons(),
                    SizedBox(height: 16.h),
                    const AppAgreement(),
                    SizedBox(height: 15.h),
                    TextButton(
                      onPressed: () {
                        _login(context);
                      },
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
