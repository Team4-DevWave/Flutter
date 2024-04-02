import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/user_system/view_model/email_signup_controller.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class EmailTextFromField extends ConsumerWidget {
  const EmailTextFromField(
      {super.key, required this.controller, required this.identifier});
  final TextEditingController controller;
  final String identifier;
  static final _key = GlobalKey();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String displayedText =
        (identifier == 'login' ? 'Email or Username' : 'Email');

    final emailSignupValidator =
        ref.watch(Validation().emailSignupValidatorProvider);

    return TextFormField(
      key: _key,
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
      validator: emailSignupValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
