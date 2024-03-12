import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle welcomeScreen = const TextStyle(
    fontFamily: 'RedditSans',
    fontSize: 44,
    color: Color.fromARGB(200, 255, 255, 255),
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.0,
  );

  static TextStyle primaryTextStyle = GoogleFonts.roboto(
    color: const Color.fromARGB(200, 255, 255, 255),
  );

  static TextStyle secondaryTextStyle = GoogleFonts.notoSans(
    color: const Color.fromARGB(200, 255, 255, 255),
  );
}
