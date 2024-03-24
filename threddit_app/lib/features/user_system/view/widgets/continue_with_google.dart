import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
<<<<<<< Updated upstream

import 'package:threddit_app/features/user_system/view_model/auth_controller.dart';

import 'package:threddit_app/theme/button_styles.dart';
import 'package:threddit_app/theme/photos.dart';
import 'package:threddit_app/theme/text_styles.dart';
=======
import 'package:threddit_clone/features/user_system/view_model/google_auth.dart';
import 'package:threddit_clone/features/user_system/view_model/google_auth_controller.dart';
import 'package:threddit_clone/theme/button_styles.dart';
import 'package:threddit_clone/theme/photos.dart';
import 'package:threddit_clone/theme/text_styles.dart';
>>>>>>> Stashed changes

class ContinueWithGoogle extends ConsumerWidget {
  const ContinueWithGoogle({super.key});

<<<<<<< Updated upstream
  void signInWithGoogle(WidgetRef ref) {
    ref.read(authControllerProvider).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      // onPressed: () {},
      /* => signInWithGoogle(ref),*/

      onPressed: () => signInWithGoogle(ref),

=======
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => ref.read(authControllerProvider).signInWithGoogle(),
>>>>>>> Stashed changes
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
