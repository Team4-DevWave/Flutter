import 'package:flutter/material.dart';
import 'package:threddit_app/theme/colors.dart';

class AppButtons {
  static ButtonStyle registerButtons = ElevatedButton.styleFrom(
    backgroundColor: AppColors.registerButtonColor,
    minimumSize: const Size(double.infinity, 50),
  );
}
