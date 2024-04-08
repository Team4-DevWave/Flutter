import 'package:flutter/material.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// Simple function that creates an alert, takes the alert name and context as
/// parameters.
void showAlert(final String alertName, BuildContext context) {
  bool isOpen = true;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          if (isOpen) {
            Navigator.of(context).pop();
            isOpen = false;
          }
        });
        return AlertDialog(
          backgroundColor: AppColors.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.bottomCenter,
          content: Text(alertName),
          contentTextStyle: AppTextStyles.secondaryTextStyle,
          insetPadding: const EdgeInsets.only(bottom: 100),
          contentPadding: const EdgeInsets.all(15),
        );
      });
}
