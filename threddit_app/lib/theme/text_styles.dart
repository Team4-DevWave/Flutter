import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:threddit_clone/theme/colors.dart';

class AppTextStyles {
  static TextStyle welcomeScreen = TextStyle(
    fontFamily: 'RedditSans',
    fontSize: 46.spMin,
    color: const Color.fromARGB(190, 255, 255, 255),
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5.w,
    height: 0.8.h,
  );

  static TextStyle primaryTextStyle = GoogleFonts.roboto(
    color: AppColors.whiteColor,
  );

  static TextStyle primaryButtonHideTextStyle = GoogleFonts.roboto(
    color: AppColors.whiteHideColor,
    fontSize: 16.spMin,
    fontWeight: FontWeight.w600,
  );

  static TextStyle primaryButtonGlowTextStyle = GoogleFonts.roboto(
    color: AppColors.whiteGlowColor,
    fontSize: 16.spMin,
    fontWeight: FontWeight.w600,
  );

  static TextStyle buttonTextStyle = GoogleFonts.roboto(
    color: const Color.fromARGB(200, 255, 255, 255),
    fontSize: 17.spMin,
  );

  static TextStyle secondaryTextStyle = GoogleFonts.notoSans(
    color: const Color.fromARGB(200, 255, 255, 255),
  );

  static TextStyle boldTextStyle = GoogleFonts.notoSans(
    fontSize: 17.sp,
    fontWeight: FontWeight.bold,
    color: const Color.fromARGB(255, 255, 255, 255),
  );
  static TextStyle boldTextStyleNotifcation = GoogleFonts.notoSans(
    fontSize: 15.sp,
    fontWeight: FontWeight.bold,
    color: const Color.fromARGB(255, 255, 255, 255),
  );
  static TextStyle secondaryTextStylenotifications = GoogleFonts.notoSans(
    color: const Color.fromARGB(166, 255, 255, 255),
    fontSize: 12.sp,
    fontWeight: FontWeight.bold,
  );
}
