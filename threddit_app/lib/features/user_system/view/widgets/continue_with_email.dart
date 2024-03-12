import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/theme/button_styles.dart';
import 'package:threddit_app/theme/text_styles.dart';

class ContinueWithEmail extends StatelessWidget {
  const ContinueWithEmail({super.key});

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
              style: AppTextStyles.primaryTextStyle.copyWith(
                fontSize: 17.spMin,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
