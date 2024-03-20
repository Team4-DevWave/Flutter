import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordForm extends StatefulWidget {
  final String formName;
  String enteredPassword = "";
  PasswordForm(this.formName);

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  bool showText = false;
  

  void changePassword(String value){
        setState(() {
          widget.enteredPassword = value;
        });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: changePassword,
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
