import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/theme/button_styles.dart';
import 'package:threddit_clone/theme/text_styles.dart';

///This customized button is customized for regiteration process screens
///to change its style depending on the validity of the screen
///
///which also take the function passed as an arguments to the consructor
///this function is customized in the screen depending on each screen
///decisions and logic.
class ContinueButton extends ConsumerWidget {
  const ContinueButton(
      {super.key,
      required this.onPressed,
      required this.isOn,
      required this.identifier});
  final Function()? onPressed;
  final bool isOn;
  final String identifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: onPressed,
      style: AppButtons.choiceButtonTheme,
      child: Text(
        identifier,
        style: isOn
            ? AppTextStyles.primaryButtonGlowTextStyle
            : AppTextStyles.primaryButtonHideTextStyle,
      ),
    );
  }
}
