import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/view/widgets/continue_button.dart';
import 'package:threddit_clone/features/user_system/view/widgets/email_textformfield.dart';
import 'package:threddit_clone/features/user_system/view/widgets/register_appbar.dart';
import 'package:threddit_clone/features/user_system/view_model/auth.dart';
import 'package:threddit_clone/features/user_system/view_model/user_system_providers.dart';
import 'package:threddit_clone/features/user_system/view_model/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgetUsername extends ConsumerStatefulWidget {
  const ForgetUsername({super.key});

  @override
  ConsumerState<ForgetUsername> createState() => _ForgetUsernameState();
}

class _ForgetUsernameState extends ConsumerState<ForgetUsername> {
  TextEditingController emailController = TextEditingController();
  bool _isValid = false;
  bool _isLoading = false;

  void updateFormValidity() {
    setState(() {
      _isValid = formSignUpKey.currentState != null &&
          formSignUpKey.currentState!.validate();
    });
  }

  Future<void> onContinue() async {
    _isLoading = true;
    final isFound = await ref
        .watch(authProvider.notifier)
        .checkEmailAvailability(emailController.text);

    _isLoading = false;
    if (isFound) {
      await ref.watch(authProvider.notifier).forgetPassword();
      showSnackBar(navigatorKey.currentContext!,
          'Email is sent to ${emailController.text}');
      ref.watch(enteredAccoutValue.notifier).state = emailController.text;
      Navigator.pushNamed(
          navigatorKey.currentContext!, RouteClass.forgetRdirectScreen);
    } else {
      showSnackBar(navigatorKey.currentContext!, 'Enter a valid email');
    }
  }

  final Uri _url = Uri.parse(
      'https://support.reddithelp.com/hc/en-us/articles/205240005-How-do-I-log-in-to-Reddit-if-I-forgot-my-password');

  Future<void> _launchUrlAgreement() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
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
                                'Reset your username',
                                style: AppTextStyles.primaryButtonGlowTextStyle
                                    .copyWith(
                                  fontSize: 24.spMin,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                "Enter your email address and we'll send you a link to reset your password",
                                style: AppTextStyles.primaryTextStyle.copyWith(
                                  fontSize: 17.spMin,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 25.h),
                              Form(
                                key: formSignUpKey,
                                onChanged: updateFormValidity,
                                child: EmailTextFromField(
                                  controller: emailController,
                                  identifier: 'signup',
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10.h),
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        const BoxDecoration(color: AppColors.backgroundColor),
                    child: ContinueButton(
                      isOn: _isValid,
                      onPressed: _isValid ? onContinue : null,
                      identifier: 'Continue',
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
