import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/user_system/view_model/validation_providers.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

String displayText(String identifier) {
  return identifier == 'login' ? 'Email or Username' : 'Email';
}

///This [EmailTextFromField] is a field that is used mainly in the regiteration process
///to take the username or email in the login screen
///or the user email in the signup screen
///
///For each process; sign up or login, there is a validation function called once
///the continue button is pressed
class EmailTextFromField extends ConsumerWidget {
  const EmailTextFromField(
      {super.key, required this.controller, required this.identifier});
  final TextEditingController controller;
  final String identifier;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String displayedText = displayText(identifier);

    final emailSignupValidator =
        ref.watch(Validation().emailSignupValidatorProvider);

    final emailLoginValidator =
        ref.watch(Validation().emailLoginValidatorProvider);
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: AppTextStyles.primaryTextStyle,
      maxLength: 50,
      cursorColor: AppColors.redditOrangeColor,
      decoration: InputDecoration(
        hintText: displayedText,
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
      validator:
          identifier == 'signup' ? emailSignupValidator : emailLoginValidator,
    );
  }
}
