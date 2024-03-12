import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle welcomeScreen = TextStyle(
    fontFamily: 'RedditSans',
    fontSize: 55.spMin,
    color: const Color.fromARGB(190, 255, 255, 255),
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5.w,
    height: 0.8.h,
  );

  static TextStyle primaryTextStyle = GoogleFonts.roboto(
    color: const Color.fromARGB(200, 255, 255, 255),
  );

  static TextStyle secondaryTextStyle = GoogleFonts.notoSans(
    color: const Color.fromARGB(200, 255, 255, 255),
  );
}
