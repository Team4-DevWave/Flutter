import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/theme/button_styles.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class ContinueButton extends ConsumerWidget {
  const ContinueButton(
      {super.key,
      required this.identifier,
      required this.onPressed,
      required this.isOn});
  final Function()? onPressed;
  final String identifier;
  final bool isOn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: onPressed,
      style: AppButtons.choiceButtonTheme,
      child: Text(
        'Continue',
        style: isOn
            ? AppTextStyles.primaryButtonGlowTextStyle
            : AppTextStyles.primaryButtonHideTextStyle,
      ),
    );
  }
}
