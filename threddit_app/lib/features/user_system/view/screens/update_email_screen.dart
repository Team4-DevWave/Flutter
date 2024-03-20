import 'package:flutter/material.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/text_styles.dart';
import 'package:threddit_app/features/user_system/view/widgets/password_form.dart';
import 'package:threddit_app/features/user_system/view/widgets/save_changes.dart';

class UpdateEmailScreen extends StatelessWidget {
  const UpdateEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Update email address"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
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
              TextFormField(
                  decoration: const InputDecoration(
                labelText: "New email address",
              )),
              const PasswordForm("Reddit password"),
              Container(
                child: TextButton(
                    onPressed: () {}, child: const Text("Forgot password?")),
                alignment: Alignment.topRight,
              ),
              const Spacer(),
              const SaveChanges(),
            ],
          ),
        ));
  }
}
