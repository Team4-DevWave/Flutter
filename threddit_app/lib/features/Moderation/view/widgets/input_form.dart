import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

// ignore: must_be_immutable
class InputForm extends StatefulWidget {
  final String formname;
  String input = "";
  InputForm(this.formname, {super.key});
  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  TextInputType? inputType;
  @override
  void initState() {
    if (widget.formname == "Ban length (days)") {
      inputType = TextInputType.number;
    } else {
      inputType = TextInputType.name;
    }
    super.initState();
  }

  void getInput(String value) {
    setState(() {
      widget.input = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: getInput,
      keyboardType: inputType,
      style: AppTextStyles.primaryTextStyle,
      maxLength: 50,
      cursorColor: AppColors.redditOrangeColor,
      decoration: InputDecoration(
        hintText: widget.formname,
        hintStyle: AppTextStyles.primaryTextStyle,
        filled: true,
        fillColor: AppColors.registerButtonColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: AppColors.whiteColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        contentPadding:
            EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 20.0.w),
        counter: const SizedBox.shrink(),
      ),
    );
  }
}
