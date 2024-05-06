import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: SizedBox(
          height: 35.h,
          child: Center(
            child: Text(
              text,
              style: AppTextStyles.primaryTextStyle.copyWith(
                color: AppColors.backgroundColor,
              ),
            ),
          ),
        ),
        backgroundColor: AppColors.whiteGlowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
}
