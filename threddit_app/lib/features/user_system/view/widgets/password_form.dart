import 'package:flutter/material.dart';

class PasswordForm extends StatefulWidget {
  final String formName;
  PasswordForm(this.formName);
  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  bool showText = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.formName,
        suffixIcon:
            IconButton(onPressed: () {
              setState(() {
                showText = !showText;
              });
            }, icon: showText ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility)),
      ),
      obscureText: !showText,
    );
  }
}
