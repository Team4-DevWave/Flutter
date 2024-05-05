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
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/features/user_system/view_model/user_system_providers.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

///This screen is responsible for taking user's inputs, validating it, and logging him in.
///
///The screen initially renders two text fields one for the user email or user name and the second
///for the user password, google sign in button, and continue button.
///
///Email text field: takes the username or email
///
///Password text field: takes the user password
///
///Google sign in button: opens the google pop up window to choose the user google account
///and then validate with the backend if the user exist or new one
///
///Continue button: when pressed the data in the email text form is validated whether it is email or username
///and saved to the user model provider, also the password is taken from the password text form field, and saved
///to the user model provider. Finally the data is sent to backend and check if the data valid then move user
///to the home screen of the application, if not the the user is showen a message that email/username or password is incorrect.
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

  Future<void> onContinue() async {
    isLoading = true;
    ref.read(authProvider.notifier).savePassword(passController.text);
    ref.read(authProvider.notifier).saveLoginEmail(emailController.text);
    final isLoggedIn = await ref.read(authProvider.notifier).login();
    isLoggedIn.fold((failure) {
      showSnackBar(navigatorKey.currentContext!, failure.message);
    }, (loggedIn) async {
      final valueEntered = ref.watch(enteredValue);
      isLoading = false;

      if (loggedIn) {
        showSnackBar(navigatorKey.currentContext!,
            'Logged you in as ${ref.watch(userProvider)!.username}');
        await ref.read(settingsFetchProvider.notifier).getMe();
        Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!,
            RouteClass.mainLayoutScreen, (Route<dynamic> route) => false);
      } else {
        showSnackBar(navigatorKey.currentContext!,
            '$valueEntered or password is incorrect');
      }
    });
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pushNamed(
                                                    context,
                                                    RouteClass
                                                        .forgotPasswordScreen),
                                            child: Text(
                                              'forgot password?',
                                              style: AppTextStyles
                                                  .primaryTextStyle
                                                  .copyWith(
                                                color:
                                                    AppColors.redditOrangeColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'OR',
                                            style:
                                                AppTextStyles.primaryTextStyle,
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pushNamed(
                                                    context,
                                                    RouteClass
                                                        .forgotUsernameScreen),
                                            child: Text(
                                              'forgot username?',
                                              style: AppTextStyles
                                                  .primaryTextStyle
                                                  .copyWith(
                                                color:
                                                    AppColors.redditOrangeColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
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
                        isOn: isValid,
                        onPressed: isValid ? onContinue : null,
                        identifier: 'Conitnue',
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
