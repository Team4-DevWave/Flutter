import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/user_mock.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view/widgets/alert.dart';
import 'package:threddit_clone/features/user_system/view/widgets/password_form.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/features/user_system/view/widgets/save_changes.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';

/// The class responsible for making the change password screen.
/// Renders the change password screen which has:
///
/// Three password forms for: Current, new and the confirmed password.
///
/// Two buttons: One to cancel and another to submit.
/// The submit button calls the save changes function which calls the change Password function.
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final PasswordForm currentPasswordForm = PasswordForm("Current password");
  final PasswordForm newPasswordForm = PasswordForm("New password");
  final PasswordForm confirmPasswordForm = PasswordForm("Confirm new password");
  final client = http.Client();
  String? token;
  void _forgetPassword() {
    Navigator.pushNamed(
        navigatorKey.currentContext!, RouteClass.forgotPasswordScreen);
  }

  Future<UserModelMe> fetchUser() async {
    return ref
        .watch(settingsFetchProvider.notifier)
        .getMe(client: client, token: token!);
  }

  Future getUserToken() async {
    String? result = await getToken();
    print(result);
    setState(() {
      token = result!;
    });
  }

  @override
  void initState() {
    getUserToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Change password"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FutureBuilder(
                future: fetchUser(),
                builder: (BuildContext ctx, AsyncSnapshot<UserModelMe> snapshot) {
                  while (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Text("ERROR LOADING USER DATA");
                  } else {
                    final UserModelMe user = snapshot.data!;
                    return Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: AppColors.redditOrangeColor,
                        ),
                        Text("u/${user.username}",
                            style: AppTextStyles.primaryTextStyle),
                      ],
                    );
                  }
                },
              ),
              currentPasswordForm,
              newPasswordForm,
              Container(
                alignment: Alignment.topRight,
                child: TextButton(
                    onPressed: () {
                      print("I am pressed");
                      return _forgetPassword();
                    },
                    child: const Text("Forgot password?")),
              ),
              confirmPasswordForm,
              const Spacer(),
              SaveChanges(
                saveChanges: () {
                  final String confirmedPassword =
                      confirmPasswordForm.enteredPassword;
                  final String newPassword = newPasswordForm.enteredPassword;
                  final String currentPassword =
                      currentPasswordForm.enteredPassword;
                  if (newPassword.length < 8 || confirmedPassword.length < 8) {
                    showAlert(
                        "Password length must be greater than 8", context);
                  } else {
                    final statusCode = changePasswordFunction(
                        client: client,
                        currentPassword: currentPassword,
                        newPassword: newPassword,
                        confirmedPassword: confirmedPassword,
                        token: token!);
                    checkPasswordChangeResponse(
                        context: context, statusCodeFuture: statusCode);
                  }
                },
              ),
            ],
          ),
        ));
  }
}
