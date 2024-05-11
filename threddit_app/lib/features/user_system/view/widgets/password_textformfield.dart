import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/user_system/view_model/validation_providers.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

///This [PasswordTextFormField] is a field that is used mainly in the regiteration process
///to take the user password in the login screen and the signup screen
///
///For each process; signup or login, there is a validation function called once
///the continue button is pressed
class PasswordTextFormField extends ConsumerStatefulWidget {
  const PasswordTextFormField(
      {super.key, required this.controller, required this.identifier});

  final TextEditingController controller;
  final String identifier;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends ConsumerState<PasswordTextFormField> {
  bool showText = false;
  @override
  Widget build(BuildContext context) {
    final passwordSignupValidator =
        ref.watch(Validation().passwordSignupValidatorProvider);

    final passwordLoginValidator =
        ref.watch(Validation().passwordLoginValidatorProvider);

    return TextFormField(
      controller: widget.controller,
      style: AppTextStyles.primaryTextStyle,
      maxLength: 50,
      cursorColor: AppColors.redditOrangeColor,
      obscureText: !showText,
      decoration: InputDecoration(
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                showText = !showText;
              });
            },
            icon: showText
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility)),
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
      validator: widget.identifier == 'signup'
          ? passwordSignupValidator
          : passwordLoginValidator,
    );
  }
}
