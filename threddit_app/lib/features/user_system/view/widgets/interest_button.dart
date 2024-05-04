import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/theme/button_styles.dart';
import 'package:threddit_clone/theme/text_styles.dart';

///This customized widget button is used to map the interests data list
///
///where it has the [answerText] and it is the displayed text on the button
///
///and [onTap] function that is passed from the interests screen
///
///and the style of the button that renders the style that depends on
///if [isSelected] is true or false
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
