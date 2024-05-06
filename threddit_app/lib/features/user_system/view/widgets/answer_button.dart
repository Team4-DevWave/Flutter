import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/theme/text_styles.dart';

///This customized widget button is used to map the gender type data list
///
///where it has the [answerText] and it is the displayed text on the button
///
///and onTap function that is passed from the about you screen
///
///and the style of the button that renders the style that depends on
///if it is selected or not
class AnswerButton extends StatelessWidget {
  const AnswerButton({
    required this.answerText,
    required this.onTap,
    required this.style,
    super.key,
  });

  final ButtonStyle? style;
  final String answerText;
  final void Function() onTap;

  @override
  Widget build(context) {
    return ElevatedButton(
      onPressed: onTap,
      style: style,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: Text(
          answerText,
          style: AppTextStyles.buttonTextStyle.copyWith(
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
