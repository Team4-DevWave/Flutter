import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/theme/colors.dart';

class AppButtons {
  static ButtonStyle registerButtons = ElevatedButton.styleFrom(
      backgroundColor: AppColors.registerButtonColor,
      // minimumSize: Size(100.w, 50.h),
      // maximumSize: Size(200.w, 75.h),
      fixedSize: Size(140.w, 55.h));
}
