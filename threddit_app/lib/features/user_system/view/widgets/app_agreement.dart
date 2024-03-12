import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppAgreement extends StatelessWidget {
  const AppAgreement({super.key});
  @override
  Widget build(BuildContext context) {
    final lisecneStyle = AppTextStyles.primaryTextStyle
        .copyWith(fontSize: 11.spMin, color: Colors.white.withOpacity(0.5));

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
              text: 'By continuing, you agree to our ', style: lisecneStyle),
          TextSpan(
            text: 'User Agreement',
            style: lisecneStyle.copyWith(color: AppColors.redditOrangeColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Handle tap on 'Privacy Policy'
              },
          ),
          TextSpan(
              text: ' and acknowledge that you understand the ',
              style: lisecneStyle),
          TextSpan(
            text: 'Privacy Policy',
            style: lisecneStyle.copyWith(color: AppColors.redditOrangeColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Handle tap on 'Privacy Policy'
              },
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}
