import 'package:flutter/material.dart';
import 'package:threddit_app/features/user_system/view/widgets/continue_with_email.dart';
import 'package:threddit_app/features/user_system/view/widgets/continue_with_google.dart';
import 'package:threddit_app/features/user_system/view/widgets/continue_with_phone.dart';

class RegisterButtons extends StatelessWidget {
  const RegisterButtons({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          ContinueWithPhone(),
          SizedBox(
            height: 10,
          ),
          ContinueWithGoogle(),
          SizedBox(
            height: 10,
          ),
          ContinueWithEmail(),
        ],
      ),
    );
  }
}
