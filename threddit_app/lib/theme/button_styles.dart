import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/text_styles.dart';

class AppButtons {
  static ButtonStyle registerButtons = ElevatedButton.styleFrom(
    backgroundColor: AppColors.registerButtonColor,
    minimumSize: Size(330.w, 50.h),
    maximumSize: Size(330.w, 55.h),
  );

  static ButtonStyle choiceButtonTheme = ElevatedButton.styleFrom(
    backgroundColor: AppColors.redditOrangeColor,
    textStyle: AppTextStyles.primaryButtonHideTextStyle,
    disabledBackgroundColor: AppColors.registerButtonColor,
    minimumSize: Size(330.w, 50.h),
    maximumSize: Size(330.w, 55.h),
  );
}
