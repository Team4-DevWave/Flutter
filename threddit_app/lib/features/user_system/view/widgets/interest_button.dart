import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/theme/button_styles.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class InterestButton extends StatelessWidget {
  const InterestButton({
    required this.answerText,
    required this.onTap,
    required this.isSelected,
    super.key,
  });

  final String answerText;
  final Function() onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: isSelected
          ? AppButtons.selectedInterestsButtons
          : AppButtons.interestsButtons,
      child: Text(
        answerText,
        textAlign: TextAlign.center,
        style: AppTextStyles.buttonTextStyle.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 12.spMin,
        ),
      ),
    );
  }
}
