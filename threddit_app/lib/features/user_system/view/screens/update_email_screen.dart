import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_app/features/user_system/view/widgets/email_form.dart';
import 'package:threddit_app/features/user_system/model/user_mock.dart';
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
  final client = http.Client();
  Future<UserMock> fetchUser() async {
    return getUserInfo(client);
  }

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
            FutureBuilder(
              future: fetchUser(),
              builder: (BuildContext ctx, AsyncSnapshot<UserMock> snapshot) {
                while (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text("ERROR LOADING USER DATA");
                } else {
                  final UserMock user = snapshot.data!;
                  return Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: AppColors.redditOrangeColor,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("u/${user.getUsername}",
                                style: AppTextStyles.primaryTextStyle),
                            Text(
                              "${user.getEmail}",
                              style: AppTextStyles.primaryTextStyle,
                            ),
                          ])
                    ],
                  );
                }
              },
            ),
            newEmailForm,
            currentPasswordForm,
            Container(
              child:
                  TextButton(onPressed: () {}, child: Text("Forgot password?")),
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
                checkEmailUpdateResponse(
                    context: context, statusCodeFuture: statusCode);
              },
            ),
          ],
        ),
      ),
    );
  }
}
