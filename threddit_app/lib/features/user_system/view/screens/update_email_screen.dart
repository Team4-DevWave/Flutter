import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/view/widgets/email_form.dart';
import 'package:threddit_clone/features/user_system/model/user_mock.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/features/user_system/view/widgets/password_form.dart';
import 'package:threddit_clone/features/user_system/view/widgets/save_changes.dart';

/// The class responsible for making the update password screen.
/// Renders the update email screen which has:
///
/// Two forms for: Current Password and New Email.
///
/// Two buttons: One to cancel and another to submit.
/// The submit button calls the save changes function which calls the change email function.
/// Then the check response.
class UpdateEmailScreen extends StatefulWidget {
  const UpdateEmailScreen({super.key});
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
        title: const Text("Update email address"),
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
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Text("ERROR LOADING USER DATA");
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
                              user.getEmail,
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
              alignment: Alignment.topRight,
              child:
                  TextButton(onPressed: () {}, child: const Text("Forgot password?")),
            ),
            const Spacer(),
            SaveChanges(
              saveChanges: () {
                final String newEmail = newEmailForm.enteredEmail;
                final String currentPassword =
                    currentPasswordForm.enteredPassword;
                final statusCode = changeEmailFunction(
                    client: client,
                    currentPassword: currentPassword,
                    newEmail: newEmail);
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
