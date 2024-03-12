import 'package:flutter/material.dart';
import 'package:threddit_app/features/user_system/view/widgets/continue_with_email.dart';
import 'package:threddit_app/features/user_system/view/widgets/continue_with_google.dart';

class RegisterButtons extends StatelessWidget {
  const RegisterButtons({super.key});
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ContinueWithGoogle(),
        SizedBox(
          height: 10,
        ),
        ContinueWithEmail(),
      ],
    );
  }
}
