import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/theme/button_styles.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class ContinueWithEmail extends ConsumerWidget {
  const ContinueWithEmail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, RouteClass.signUpScreen);
      },
      style: AppButtons.registerButtons,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 30.w,
              height: 30.h,
              child: const Icon(
                Icons.email,
                color: Colors.white,
              ),
            ),
            Text(
              'Continue with email',
              style: AppTextStyles.buttonTextStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
