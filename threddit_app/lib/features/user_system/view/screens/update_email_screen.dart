import 'package:flutter/material.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/text_styles.dart';
import 'package:threddit_app/features/user_system/view/widgets/password_form.dart';
import 'package:threddit_app/features/user_system/view/widgets/save_changes.dart';

class UpdateEmailScreen extends StatelessWidget {
  const UpdateEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
              TextFormField(
                  decoration: InputDecoration(
                labelText: "New email address",
              )),
              PasswordForm("Reddit password"),
              Container(
                child: TextButton(
                    onPressed: () {}, child: Text("Forgot password?")),
                alignment: Alignment.topRight,
              ),
              Spacer(),
              SaveChanges(saveChanges: (){

              },),
            ],
          ),
        ));
  }
}
