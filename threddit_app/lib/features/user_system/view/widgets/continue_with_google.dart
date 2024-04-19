// ignore_for_file: no_leading_underscores_for_local_identifiers

// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/features/user_system/view_model/auth.dart';
// import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/google_auth_controller.dart';
// import 'package:threddit_clone/features/user_system/view_model/window_auth_service.dart';

import 'package:threddit_clone/theme/button_styles.dart';
import 'package:threddit_clone/theme/photos.dart';
import 'package:threddit_clone/theme/text_styles.dart';

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
        print("HERE Continue with google");
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
