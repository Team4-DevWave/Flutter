import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/theme/button_styles.dart';
import 'package:threddit_app/theme/photos.dart';
import 'package:threddit_app/theme/text_styles.dart';

class ContinueWithGoogle extends StatelessWidget {
  const ContinueWithGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
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
              style: AppTextStyles.primaryTextStyle.copyWith(
                fontSize: 17.spMin,
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
