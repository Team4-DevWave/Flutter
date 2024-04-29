import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view/widgets/email_form.dart';
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
  Future<UserModelMe> fetchUser() async {
    setState(() {
      ref.watch(settingsFetchProvider.notifier).getMe();
    });
    return ref.watch(settingsFetchProvider.notifier).getMe();
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
              builder: (BuildContext ctx, AsyncSnapshot<UserModelMe> snapshot) {
                while (snapshot.connectionState == ConnectionState.waiting) {
                  return Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: AppColors.redditOrangeColor,
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("u/",
                                style: AppTextStyles.primaryTextStyle),
                          ])
                    ],
                  );
                }
                if (snapshot.hasError) {
                  return const Text("ERROR LOADING USER DATA");
                } else {
                  final UserModelMe user = snapshot.data!;
                  return Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: AppColors.redditOrangeColor,
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("u/${user.username}",
                                style: AppTextStyles.primaryTextStyle),
                            Text(
                              user.email!,
                              style: AppTextStyles.primaryTextStyle,
                            ),
                          ])
                    ],
                  );
                }
              },
            ),
            newEmailForm,
            //currentPasswordForm,
            Container(
              alignment: Alignment.topRight,
              child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, RouteClass.forgotPasswordScreen);
                  },
                  child: Text(
                    "Forgot password?",
                    style: AppTextStyles.primaryTextStyle.copyWith(
                      color: AppColors.redditOrangeColor,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ),
            const Spacer(),
            SaveChanges(
              saveChanges: () async {
                final String newEmail = newEmailForm.enteredEmail;
                //final String currentPassword =
                currentPasswordForm.enteredPassword;
                changeEmailFunction(
                  newEmail: newEmail,
                ).then((value) {
                  checkEmailUpdateResponse(
                      context: context, statusCodeFuture: value);
                  setState(() {
                    ref.watch(settingsFetchProvider.notifier).getMe();
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
