import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/view/widgets/app_agreement.dart';
import 'package:threddit_clone/features/user_system/view/widgets/continue_button.dart';
import 'package:threddit_clone/features/user_system/view/widgets/continue_with_google.dart';
import 'package:threddit_clone/features/user_system/view/widgets/email_textformfield.dart';
import 'package:threddit_clone/features/user_system/view/widgets/password_textformfield.dart';
import 'package:threddit_clone/features/user_system/view/widgets/register_appbar.dart';
import 'package:threddit_clone/features/user_system/view_model/auth.dart';
import 'package:threddit_clone/features/user_system/view_model/navigate_login.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

///This screen is responsible for taking user's inputs, validating it, and continue to next step
///in the registration process.
///
///The screen initially renders two text fields one for the user email and the second
///for the user password, google sign in button, and continue button.
///
///Email text field: takes the user email and continuously checking if the inserted
///value is a real email format if not an appropriate error message is shown to the user.
///
///Password text field: takes the user password and continously checking if the entered value
///is shorter than eight charachters and show appropriate error message to the user.
///
///Google sign in button: opens the google pop up window to choose the user google account
///and then validate with the backend if the user exist or new one
///
///Continue button: this button is not enables unless all text fields passed its validations.
///When pressed the data in the email text form is validated whether this email is free to be used
///or used before and saved to the user model provider, also the password is taken from the password text form field, and saved
///to the user model provider. Finally the user is moved to the next step if passed all validations
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
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
    ref.read(authProvider.notifier).savePassword(passController.text);
    final isUsed = await ref
        .read(authProvider.notifier)
        .checkEmailAvailability(emailController.text);

    isUsed.fold(
      (failure) {
        showSnackBar(navigatorKey.currentContext!, failure.message);
      },
      (isEmailUsed) {
        if (isEmailUsed) {
          showSnackBar(navigatorKey.currentContext!, 'email is already found');
        } else {
          ref.read(authProvider.notifier).saveEmail(emailController.text);
          Navigator.pushNamed(
              navigatorKey.currentContext!, RouteClass.aboutMeScreen);
        }
      },
    );

    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    _isLoading = ref.watch(authProvider);
    return PopScope(
      onPopInvoked: (context) => formSignUpKey.currentState?.reset(),
      child: _isLoading
          ? const Loading()
          : Scaffold(
              appBar: RegisterAppBar(
                action: () => ref.read(navgationProvider)(context),
                title: 'Log in',
              ),
              body: Container(
                margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.h),
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
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Column(
                              children: [
                                SizedBox(height: 20.h),
                                Text(
                                  'Hi new friend, welcome to Reddit',
                                  style:
                                      AppTextStyles.primaryTextStyle.copyWith(
                                    fontSize: 28.spMin,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 25.h),
                                const ContinueWithGoogle(),
                                SizedBox(height: 15.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: AppColors.whiteColor,
                                        height: 1.h,
                                        thickness: 1.h,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 13.w),
                                      child: Text(
                                        'OR',
                                        style: AppTextStyles.primaryTextStyle,
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: AppColors.whiteColor,
                                        height: 1.h,
                                        thickness: 1.h,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 13.h),
                                Form(
                                  onPopInvoked: (_) => FocusManager
                                      .instance.primaryFocus
                                      ?.unfocus(),
                                  key: formSignUpKey,
                                  onChanged: updateFormValidity,
                                  child: Column(
                                    children: [
                                      EmailTextFromField(
                                        controller: emailController,
                                        identifier: 'signup',
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      PasswordTextFormField(
                                        controller: passController,
                                        identifier: 'signup',
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                const AppAgreement(),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 10.h),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            color: AppColors.backgroundColor),
                        child: ContinueButton(
                          isOn: _isValid,
                          onPressed: _isValid ? onContinue : null,
                          identifier: 'Continue',
                        )),
                  ],
                ),
              ),
            ),
    );
  }
}
