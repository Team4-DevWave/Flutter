import 'package:flutter/material.dart';

class PasswordForm extends StatefulWidget {
  final String formName;
  const PasswordForm(this.formName, {super.key});
  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  bool showText = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.formName,
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                showText = !showText;
              });
              // ignore: lines_longer_than_80_chars
            },
            icon: showText
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility)),
      ),
      obscureText: !showText,
    );
  }
}
