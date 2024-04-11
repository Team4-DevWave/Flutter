import 'package:flutter/material.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// Creates a password text form, takes the form name as a parameter.
// ignore: must_be_immutable
class PasswordForm extends StatefulWidget {
  final String formName;
  String enteredPassword = "";
  PasswordForm(this.formName, {super.key});

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  bool showText = false;

  void getPassword(String value) {
    setState(() {
      widget.enteredPassword = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: AppTextStyles.primaryTextStyle,
      onChanged: getPassword,
      decoration: InputDecoration(
        labelText: widget.formName,
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                showText = !showText;
              });
            },
            icon: showText
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility)),
      ),
      obscureText: !showText,
    );
  }
}
