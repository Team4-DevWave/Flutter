import 'package:flutter/material.dart';
import 'package:threddit_app/theme/button_styles.dart';
import 'package:threddit_app/theme/text_styles.dart';

class ContinueWithPhone extends StatelessWidget {
  const ContinueWithPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: AppButtons.registerButtons,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            const Icon(
              Icons.phone_android,
              color: Colors.white,
            ),
            const SizedBox(
              width: 41,
            ),
            Text(
              'Continue with phone number',
              style: AppTextStyles.registerButtons,
            ),
          ],
        ),
      ),
    );
  }
}
