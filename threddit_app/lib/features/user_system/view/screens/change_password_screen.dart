import 'package:flutter/material.dart';
import 'package:threddit_app/features/user_system/view/widgets/password_form.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/text_styles.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

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
                  Icon(
                    Icons.person,
                    color: AppColors.redditOrangeColor,
                  ),
                  Text("u/xxxxx", style: AppTextStyles.primaryTextStyle),
                ],
              ),
              
              PasswordForm("Current password"),
              PasswordForm("New password"),
              Container(
                child:
                    TextButton(onPressed: () {}, child: Text("Forgot password?")),
                alignment: Alignment.topRight,
              ),
              PasswordForm("Confirm new password"),
            ],
          ),
        ));
  }
}
