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
import 'package:threddit_clone/features/user_system/view_model/navigate_signup.dart';
import 'package:threddit_clone/features/user_system/view_model/user_system_providers.dart';
import 'package:threddit_clone/features/user_system/view_model/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

class LogInScreen extends ConsumerStatefulWidget {
  const LogInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LogInScreenState();
}

class _LogInScreenState extends ConsumerState<LogInScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool isValid = false;
  bool isLoading = false;

  void updateFormValidity() {
    setState(() {
      isValid = formLogInKey.currentState != null &&
          formLogInKey.currentState!.validate();
    });
  }

  //WILL BE CHANGED
  //send data to backend
  //if returned fail show a box representing error and do not navigate
  //if returned success take the token store it to shared prefrences then update success then move to mainlayout screen
  Future<void> onContinue() async {
    isLoading = true;
    ref.read(authProvider.notifier).savePassword(passController.text);
    ref.read(authProvider.notifier).saveLoginEmail(emailController.text);
    await ref.read(authProvider.notifier).login();
    final isSucceeded = ref.watch(succeeded);
    final valueEntered = ref.watch(enteredValue);
    isLoading = false;

    if (isSucceeded) {
      Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!,
          RouteClass.mainLayoutScreen, (Route<dynamic> route) => false);
    } else {
      showSnackBar(navigatorKey.currentContext!,
          '$valueEntered or password is incorrect');
    }
  }

  @override
  Widget build(BuildContext context) {
    isLoading = ref.watch(authProvider);
    return PopScope(
      onPopInvoked: (context) => formLogInKey.currentState?.reset(),
      child: isLoading
          ? const Loading()
          : Scaffold(
              appBar: RegisterAppBar(
                action: () => ref.read(navigateSignup)(context),
                title: 'Sign up',
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
                                  'Log in to Reddit',
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
                                  key: formLogInKey,
                                  onChanged: updateFormValidity,
                                  child: Column(
                                    children: [
                                      EmailTextFromField(
                                        controller: emailController,
                                        identifier: 'login',
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      PasswordTextFormField(
                                        controller: passController,
                                        identifier: 'login',
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                'Forget password?',
                                                style: AppTextStyles
                                                    .primaryTextStyle
                                                    .copyWith(
                                                  color: AppColors
                                                      .redditOrangeColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )),
                                        ],
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
                      decoration:
                          const BoxDecoration(color: AppColors.backgroundColor),
                      child: ContinueButton(
                        identifier: 'login',
                        isOn: isValid,
                        onPressed: isValid ? onContinue : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
