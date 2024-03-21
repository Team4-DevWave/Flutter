import 'package:flutter/material.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/text_styles.dart';

void showAlert(final String alertName) {
  bool isOpen = true;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
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
          insetPadding: EdgeInsets.only(bottom: 100),
          contentPadding: EdgeInsets.all(15),
        );
      });
}
