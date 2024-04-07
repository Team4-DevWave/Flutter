import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class AppButtons {
  static ButtonStyle registerButtons = ElevatedButton.styleFrom(
    backgroundColor: AppColors.registerButtonColor,
    minimumSize: Size(330.w, 50.h),
    maximumSize: Size(330.w, 55.h),
  );

  static ButtonStyle selectedButtons = ElevatedButton.styleFrom(
    backgroundColor: AppColors.redditHideOrangeColor,
    side: const BorderSide(
      color: AppColors.redditOrangeColor,
      width: 2.0,
    ),
    minimumSize: Size(330.w, 50.h),
    maximumSize: Size(330.w, 55.h),
  );

  static ButtonStyle interestsButtons = ElevatedButton.styleFrom(
    backgroundColor: AppColors.registerButtonColor,
  );

  static ButtonStyle selectedInterestsButtons = ElevatedButton.styleFrom(
    backgroundColor: AppColors.redditHideOrangeColor,
    side: const BorderSide(
      color: AppColors.redditOrangeColor,
      width: 1.0,
    ),
  );

  static ButtonStyle choiceButtonTheme = ElevatedButton.styleFrom(
    backgroundColor: AppColors.redditOrangeColor,
    textStyle: AppTextStyles.primaryButtonHideTextStyle,
    disabledBackgroundColor: AppColors.registerButtonColor,
    minimumSize: Size(330.w, 50.h),
    maximumSize: Size(330.w, 55.h),
  );
}
