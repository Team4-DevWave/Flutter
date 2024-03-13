import 'package:flutter/material.dart';
import 'package:threddit_app/theme/colors.dart';

//Overriding some prefered themes
final redditTheme = ThemeData().copyWith(
  scaffoldBackgroundColor: AppColors.backgroundColor,
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: AppColors.backgroundColor,
    foregroundColor: Colors.white.withOpacity(0.5),
  ),
);
