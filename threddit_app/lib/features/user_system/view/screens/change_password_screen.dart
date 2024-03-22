import 'package:flutter/material.dart';
import 'package:threddit_app/features/user_system/view/widgets/password_form.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/text_styles.dart';
import 'package:threddit_app/features/user_system/view/widgets/save_changes.dart';
import 'package:threddit_app/features/user_system/view_model/settings_functions.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({super.key});
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final PasswordForm currentPasswordForm = PasswordForm("Current password");
  final PasswordForm newPasswordForm = PasswordForm("New password");
  final PasswordForm confirmPasswordForm = PasswordForm("Confirm new password");
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        appBar: AppBar(
          title: Text("Change password"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: AppColors.redditOrangeColor,
                  ),
                  Text("u/xxxxx", style: AppTextStyles.primaryTextStyle),
                ],
              ),
              currentPasswordForm,
              newPasswordForm,
              Container(
                child: TextButton(
                    onPressed: () {}, child: Text("Forgot password?")),
                alignment: Alignment.topRight,
              ),
              confirmPasswordForm,
              Spacer(),
              SaveChanges(
                saveChanges: () {
                  final String confirmedPassword =
                      confirmPasswordForm.enteredPassword;
                  final String newPassword = newPasswordForm.enteredPassword;
                  final String currentPassword =
                      currentPasswordForm.enteredPassword;
                  final statusCode = changePasswordFunction(
                      currentPassword: currentPassword,
                      newPassword: newPassword,
                      confirmedPassword: confirmedPassword);
                  checkPasswordChangeResponse(context: context, statusCodeFuture: statusCode);
                },
              ),
            ],
          ),
        ));
  }
}
