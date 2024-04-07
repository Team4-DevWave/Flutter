import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/user_system/view/widgets/continue_button.dart';
import 'package:threddit_clone/features/user_system/view/widgets/register_appbar.dart';
import 'package:threddit_clone/features/user_system/view_model/auth.dart';
import 'package:threddit_clone/features/user_system/view_model/user_system_providers.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/photos.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgetSentMail extends ConsumerStatefulWidget {
  const ForgetSentMail({super.key});

  @override
  ConsumerState<ForgetSentMail> createState() => _ForgetSentMail();
}

class _ForgetSentMail extends ConsumerState<ForgetSentMail> {
  bool _isLoading = false;
  Future<void> onContinue() async {}

  final Uri _url = Uri.parse(
      'https://support.reddithelp.com/hc/en-us/articles/205240005-How-do-I-log-in-to-Reddit-if-I-forgot-my-password');

  Future<void> _launchUrlAgreement() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    _isLoading = ref.watch(authProvider);

    return _isLoading
        ? const Loading()
        : Scaffold(
            appBar: RegisterAppBar(
                action: () => _launchUrlAgreement(), title: 'Help'),
            body: Container(
              margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.h),
              height: MediaQuery.of(context).size.height.h,
              width: MediaQuery.of(context).size.width.w,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            children: [
                              SizedBox(height: 20.h),
                              Text(
                                'Check you inbox',
                                style: AppTextStyles.primaryButtonGlowTextStyle
                                    .copyWith(
                                  fontSize: 24.spMin,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                "A link to reset your password was sent to ${ref.watch(enteredAccoutValue)}",
                                style: AppTextStyles.primaryTextStyle.copyWith(
                                  fontSize: 16.spMin,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 35.h),
                              SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: Image.asset(Photos.avatar))
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Didn't get email? ",
                          style: AppTextStyles.primaryButtonHideTextStyle,
                        ),
                        TextSpan(
                          text: "Resend",
                          style: AppTextStyles.primaryButtonGlowTextStyle,
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10.h),
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        const BoxDecoration(color: AppColors.backgroundColor),
                    child: ContinueButton(
                      isOn: true,
                      onPressed: onContinue,
                      identifier: 'Open email app',
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
