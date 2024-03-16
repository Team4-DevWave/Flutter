import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/text_styles.dart';

class TextForm extends StatelessWidget {
  const TextForm({super.key, required this.identifier});

  final String identifier;

  @override
  Widget build(BuildContext context) {
    final displayedText =
        (identifier == 'login' ? 'Email or Username' : 'Email');
    return Form(
      child: Column(
        children: [
          TextFormField(
            style: AppTextStyles.primaryTextStyle,
            maxLength: 50,
            decoration: InputDecoration(
              hintText: displayedText,
              hintStyle: AppTextStyles.primaryTextStyle,
              filled: true,
              fillColor: AppColors.registerButtonColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(color: AppColors.whiteColor),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 18.0.h, horizontal: 20.0.w),
              counter: const SizedBox.shrink(),
            ),
            validator: (value) => '',
          ),
          TextFormField(
            style: AppTextStyles.primaryTextStyle,
            maxLength: 50,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: AppTextStyles.primaryTextStyle,
              filled: true,
              fillColor: AppColors.registerButtonColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0.r),
                borderSide: const BorderSide(color: AppColors.whiteColor),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 18.0.h, horizontal: 20.0.w),
              counter: const SizedBox.shrink(),
            ),
            validator: (value) => '',
          ),
        ],
      ),
    );
  }
}
