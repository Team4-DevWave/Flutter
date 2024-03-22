import 'package:flutter/material.dart';
import 'package:threddit_app/features/user_system/view/widgets/email_form.dart';
import 'package:threddit_app/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/text_styles.dart';
import 'package:threddit_app/features/user_system/view/widgets/password_form.dart';
import 'package:threddit_app/features/user_system/view/widgets/save_changes.dart';

class UpdateEmailScreen extends StatefulWidget {
  UpdateEmailScreen({super.key});
  @override
  _UpdateEmailScreenState createState() => _UpdateEmailScreenState();
}

class _UpdateEmailScreenState extends State<UpdateEmailScreen> {
  final PasswordForm currentPasswordForm = PasswordForm("Reddit password");
  final EmailForm newEmailForm = EmailForm("New email address");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update email address"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: AppColors.redditOrangeColor,
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("u/xxxxx", style: AppTextStyles.primaryTextStyle),
                      Text(
                        "xxxxxxxx@gmail.com",
                        style: AppTextStyles.primaryTextStyle,
                      ),
                    ])
              ],
            ),
            newEmailForm,
            currentPasswordForm,
            Container(
              child: TextButton(
                  onPressed: () {}, child: Text("Forgot password?")),
              alignment: Alignment.topRight,
            ),
            Spacer(),
            SaveChanges(
              saveChanges: () {
                final String newEmail = newEmailForm.enteredEmail;
                final String currentPassword =
                    currentPasswordForm.enteredPassword;
                final statusCode = changeEmailFunction(
                    currentPassword: currentPassword, newEmail: newEmail);
                checkEmailUpdateResponse(context: context, statusCodeFuture: statusCode);
              },
            ),
          ],
        ),
      ),
    );
  }
}
