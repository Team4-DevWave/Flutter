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
import 'package:threddit_clone/features/user_system/view_model/user_system_providers.dart';
import 'package:threddit_clone/features/user_system/view_model/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool isValid = false;
  bool isLoading = false;
  void updateFormValidity() {
    setState(() {
      isValid = formSignUpKey.currentState != null &&
          formSignUpKey.currentState!.validate();
    });
  }

  Future<void> onContinue() async {
    isLoading = true;
    ref.read(authProvider.notifier).savePassword(passController.text);
    await ref.read(authProvider.notifier).saveEmail(emailController.text);
    final isNew = ref.watch(isNewProvider);
    isLoading = false;

    if (isNew) {
      Navigator.pushNamed(
          navigatorKey.currentContext!, RouteClass.aboutMeScreen);
    } else {
      showSnackBar(navigatorKey.currentContext!, 'email is already found');
    }
  }

  @override
  Widget build(BuildContext context) {
    isLoading = ref.watch(authProvider);
    return PopScope(
      onPopInvoked: (context) => formSignUpKey.currentState?.reset(),
      child: isLoading
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
                          identifier: 'signup',
                          isOn: isValid,
                          onPressed: isValid ? onContinue : null,
                        )),
                  ],
                ),
              ),
            ),
    );
  }
}
