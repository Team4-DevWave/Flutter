import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle welcomeScreen = const TextStyle(
    fontFamily: 'RedditSans',
    fontSize: 44,
    color: Color.fromARGB(210, 255, 255, 255),
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.0,
  );

  static TextStyle registerButtons = GoogleFonts.roboto(
    color: Colors.white,
    fontSize: 19,
    fontWeight: FontWeight.w600,
  );
}
