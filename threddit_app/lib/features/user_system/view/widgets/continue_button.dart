import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_app/features/home_page/view/home_screen.dart';
import 'package:threddit_app/features/user_system/view_model/continue_signup_controller.dart';
import 'package:threddit_app/theme/button_styles.dart';
import 'package:threddit_app/theme/text_styles.dart';

class ContinueButton extends ConsumerWidget {
  const ContinueButton({super.key, required this.identifier});

  final String identifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOn = ref.watch(continueSignupProvider);
    return ElevatedButton(
      onPressed: isOn
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const HomeScreen(),
                ),
              );
            }
          : null,
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
