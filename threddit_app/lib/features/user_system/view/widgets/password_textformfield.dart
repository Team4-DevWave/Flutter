import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/user_system/view_model/validation_providers.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class PasswordTextFormField extends ConsumerWidget {
  const PasswordTextFormField(
      {super.key, required this.controller, required this.identifier});
  final TextEditingController controller;
  final String identifier;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordSignupValidator =
        ref.watch(Validation().passwordSignupValidatorProvider);

    final passwordLoginValidator =
        ref.watch(Validation().passwordLoginValidatorProvider);

    return TextFormField(
      controller: controller,
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: identifier == 'signup'
          ? passwordSignupValidator
          : passwordLoginValidator,
    );
  }
}
