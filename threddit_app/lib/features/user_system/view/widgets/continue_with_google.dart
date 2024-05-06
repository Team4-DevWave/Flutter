import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/features/user_system/view_model/auth.dart';
import 'package:threddit_clone/theme/button_styles.dart';
import 'package:threddit_clone/theme/photos.dart';
import 'package:threddit_clone/theme/text_styles.dart';

///[ContinueWithGoogle] button is used to controll the sign is with google process,
///where first of all the sign is with google function is called to open the google pop up
///window, and the user select his prefered google account, then check if the email
///is already found user to log him in or new one to start with the about you screen
///as a first step for the user account registration process
class ContinueWithGoogle extends ConsumerWidget {
  const ContinueWithGoogle({super.key});

  void onContinue(BuildContext context, WidgetRef ref) async {
    final response = await ref.watch(authProvider.notifier).signInWithGoogle();
    response.fold(
        (failure) =>
            showSnackBar(navigatorKey.currentContext!, failure.message),
        (isFound) {
      if (isFound) {
        Navigator.pushNamedAndRemoveUntil(
          navigatorKey.currentContext!,
          RouteClass.mainLayoutScreen,
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pushNamed(
            navigatorKey.currentContext!, RouteClass.aboutMeScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        onContinue(context, ref);
      },
      style: AppButtons.registerButtons,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Photos.googleLogo,
              width: 30.w,
              height: 30.h,
            ),
            Text(
              'Continue with Google',
              style: AppTextStyles.buttonTextStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
