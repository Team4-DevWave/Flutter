import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/user_system/view/widgets/continue_with_email.dart';
import 'package:threddit_clone/features/user_system/view/widgets/continue_with_google.dart';

class RegisterButtons extends StatelessWidget {
  const RegisterButtons({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ContinueWithGoogle(),
        SizedBox(
          height: 10.h,
        ),
        const ContinueWithEmail(),
      ],
    );
  }
}
