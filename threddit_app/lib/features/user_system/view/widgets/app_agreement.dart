import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _urlAgreement =
    Uri.parse('https://www.redditinc.com/policies/user-agreement');
final Uri _urlPrivacy =
    Uri.parse('https://www.reddit.com/policies/privacy-policy');

Future<void> _launchUrlAgreement() async {
  if (!await launchUrl(_urlAgreement)) {
    throw Exception('Could not launch $_urlAgreement');
  }
}

Future<void> _launchUrlPrivacy() async {
  if (!await launchUrl(_urlPrivacy)) {
    throw Exception('Could not launch $_urlPrivacy');
  }
}

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
            recognizer: TapGestureRecognizer()..onTap = _launchUrlAgreement,
          ),
          TextSpan(
              text: ' and acknowledge that you understand the ',
              style: lisecneStyle),
          TextSpan(
            text: 'Privacy Policy',
            style: lisecneStyle.copyWith(color: AppColors.redditOrangeColor),
            recognizer: TapGestureRecognizer()..onTap = _launchUrlPrivacy,
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}
