import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/theme/button_styles.dart';
import 'package:threddit_clone/theme/text_styles.dart';

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
