import 'package:flutter/material.dart';
import 'package:threddit_app/features/user_system/view/widgets/password_form.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/text_styles.dart';
import 'package:threddit_app/features/user_system/view/widgets/save_changes.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

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
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: AppColors.redditOrangeColor,
                  ),
                  Text("u/xxxxx", style: AppTextStyles.primaryTextStyle),
                ],
              ),
              const PasswordForm("Current password"),
              const PasswordForm("New password"),
              Container(
                alignment: Alignment.topRight,
                child: TextButton(
                    onPressed: () {}, child: const Text("Forgot password?")),
              ),
              const PasswordForm("Confirm new password"),
              const Spacer(),
              const SaveChanges(),
            ],
          ),
        ));
  }
}
