import 'package:flutter/material.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/user_mock.dart';
import 'package:threddit_clone/features/user_system/view/widgets/password_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/view/widgets/save_changes.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class ConfirmPasswordScreen extends ConsumerStatefulWidget {
  const ConfirmPasswordScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmPasswordScreenState();
}

class _ConfirmPasswordScreenState extends ConsumerState<ConfirmPasswordScreen> {
  final PasswordForm confirmPasswordForm = PasswordForm("Reddit Password");
  final client = http.Client();
  String? token;
  Future<UserMock> fetchUser() async {
    return ref
        .watch(settingsFetchProvider.notifier)
        .getUserInfo(client: client, token: token!);
  }

  Future getUserToken() async {
    String? result = await getToken();
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
        title: const Text('Confirm password'),
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: fetchUser(),
              builder: (context, snapshot) {
                while (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
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
              }),
          confirmPasswordForm,
          const Spacer(),
          SaveChanges(
            saveChanges: () {
              final String confirmPassword =
                  confirmPasswordForm.enteredPassword;
              //if (confirmPassword.length < 8) {
              // showAlert(
              // "Password length must be greater than 8", context);
              //} else {
              final statusCode = confirmPasswordFunction(
                  client: client,
                  confirmedPassword: confirmPassword,
                  token: token!);
              ref
                  .watch(settingsFetchProvider.notifier)
                  .checkPasswordConfirmResponse(
                      context: context, statusCodeFuture: statusCode);

              //}
            },
          )
        ],
      ),
    );
  }
}
