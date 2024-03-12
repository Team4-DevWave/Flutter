import 'package:flutter/material.dart';
import 'package:threddit_app/theme/button_styles.dart';
import 'package:threddit_app/theme/photos.dart';
import 'package:threddit_app/theme/text_styles.dart';

class ContinueWithGoogle extends StatelessWidget {
  const ContinueWithGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: AppButtons.registerButtons,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Image.asset(
              Photos.googleLogo,
              width: 35,
            ),
            const SizedBox(
              width: 51,
            ),
            Text(
              'Continue with Google',
              style: AppTextStyles.primaryTextStyle.copyWith(
                fontSize: 19,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
