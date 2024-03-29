import 'package:flutter/material.dart';
import 'package:threddit_clone/theme/colors.dart';

//Overriding some prefered themes
final redditTheme = ThemeData().copyWith(
  scaffoldBackgroundColor: AppColors.backgroundColor,
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: AppColors.backgroundColor,
    foregroundColor: Colors.white.withOpacity(0.5),
  ),
);

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.redditOrangeColor,
      ),
    );
  }
}
