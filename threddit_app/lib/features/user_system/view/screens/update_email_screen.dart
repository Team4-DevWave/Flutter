import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
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
class UpdateEmailScreen extends ConsumerStatefulWidget {
  const UpdateEmailScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateEmailScreenState();
}

class _UpdateEmailScreenState extends ConsumerState<UpdateEmailScreen> {
  final PasswordForm currentPasswordForm = PasswordForm("Reddit password");
  final EmailForm newEmailForm = EmailForm("New email address");
  final client = http.Client();
  String? token;
  Future<UserMock> fetchUser() async {
    setState(() {
      ref
          .watch(settingsFetchProvider.notifier)
          .getUserInfo(client: client, token: token!);
    });
    return ref
        .watch(settingsFetchProvider.notifier)
        .getUserInfo(client: client, token: token!);
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
              child: TextButton(
                  onPressed: () {}, child: const Text("Forgot password?")),
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
                    newEmail: newEmail,
                    token: token!);
                checkEmailUpdateResponse(
                    context: context, statusCodeFuture: statusCode);
                setState(() {
                  ref
                      .watch(settingsFetchProvider.notifier)
                      .getUserInfo(client: client, token: token!);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
