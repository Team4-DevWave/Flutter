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
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

///[ForgotPassword] screen start by rendering: input field, continue button, and help button
///
///Each of these has a main role in the screen;
///
///Input filed: takes the email or username of the user to send the reset password mail to
///
///Help button: makes the user able to view the Q/A of the forget process and reach the contact support
///
///Continue button: is responsible to send the reset password mail if the entered a valid user name or email,
///after pressing on the the continue, will check whether the entered value is emial or user name and check
///its validity and continue the reset password process.
class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});
  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  bool _isValid = false;
  bool _isLoading = false;

  void updateFormValidity() {
    setState(() {
      _isValid =
          forgotKey.currentState != null && forgotKey.currentState!.validate();
    });
  }

  Future<void> onContinue() async {
    _isLoading = true;
    ref.watch(authProvider.notifier).saveLoginEmail(emailController.text);
    final enteredCred = ref.watch(enteredValue);

    final isFound = enteredCred == 'email'
        ? await ref
            .watch(authProvider.notifier)
            .checkEmailAvailability(emailController.text)
        : await ref
            .watch(authProvider.notifier)
            .checkUsernameAvailability(emailController.text);

    _isLoading = false;
    isFound.fold((failure) {
      showSnackBar(navigatorKey.currentContext!, failure.message);
    }, (userFound) async {
      if (userFound) {
        final forgot = await ref.watch(authProvider.notifier).forgotPassword();
        forgot.fold(
          (forgotFailure) {
            showSnackBar(navigatorKey.currentContext!, forgotFailure.message);
          },
          (forgotSuccess) {
            if (forgotSuccess) {
              ref.watch(enteredAccoutValue.notifier).state =
                  emailController.text;
              showSnackBar(navigatorKey.currentContext!,
                  'Email is sent to ${emailController.text}');
              ref.watch(forgotType.notifier).update((state) => 'password');
              Navigator.pushNamed(
                  navigatorKey.currentContext!, RouteClass.forgotRdirectScreen);
            } else {
              showSnackBar(navigatorKey.currentContext!,
                  'somehting went wrong, try again later!');
            }
          },
        );
      } else {
        showSnackBar(
            navigatorKey.currentContext!, 'Enter a valid $enteredCred');
      }
    });
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
                                'Reset your password',
                                style: AppTextStyles.primaryButtonGlowTextStyle
                                    .copyWith(
                                  fontSize: 24.spMin,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                "Enter your email address or username and we'll send you a link to reset your password",
                                style: AppTextStyles.primaryTextStyle.copyWith(
                                  fontSize: 17.spMin,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 25.h),
                              Form(
                                key: forgotKey,
                                onChanged: updateFormValidity,
                                child: EmailTextFromField(
                                  controller: emailController,
                                  identifier: 'login',
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
