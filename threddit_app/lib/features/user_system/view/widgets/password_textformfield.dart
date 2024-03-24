import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/features/user_system/view_model/email_signup_controller.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/text_styles.dart';

class PasswordTextFormField extends ConsumerWidget {
  const PasswordTextFormField(
      {super.key, required this.controller, required this.identifier});

  final String identifier;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passowrdSignupValidator =
        ref.watch(Validation().passwordSignupValidatorProvider);

    return TextFormField(
      style: AppTextStyles.primaryTextStyle,
      maxLength: 50,
      cursorColor: AppColors.redditOrangeColor,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: AppTextStyles.primaryTextStyle,
        filled: true,
        fillColor: AppColors.registerButtonColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: AppColors.whiteColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        contentPadding:
            EdgeInsets.symmetric(vertical: 18.0.h, horizontal: 20.0.w),
        counter: const SizedBox.shrink(),
      ),
      validator: passowrdSignupValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
