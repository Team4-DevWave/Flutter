// text_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/features/user_system/view/widgets/email_textformfield.dart';
import 'package:threddit_app/features/user_system/view/widgets/password_textformfield.dart';
import 'package:threddit_app/features/user_system/view_model/continue_signup_controller.dart';

class TextForm extends ConsumerWidget {
  const TextForm({super.key, required this.identifier});

  final String identifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordController = TextEditingController();
    final emailController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    void updateFormValidity() {
      final isValid =
          formKey.currentState != null && formKey.currentState!.validate();
      ref.read(continueSignupProvider.notifier).updateFormValidity(isValid);
    }

    return Form(
      key: formKey,
      onChanged: updateFormValidity,
      child: Column(
        children: [
          EmailTextFromField(
            controller: emailController,
            identifier: identifier,
          ),
          SizedBox(
            height: 8.h,
          ),
          PasswordTextFormField(
            controller: passwordController,
            identifier: identifier,
          ),
        ],
      ),
    );
  }
}
