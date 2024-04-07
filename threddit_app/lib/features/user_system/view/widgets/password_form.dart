import 'package:flutter/material.dart';
/// Creates a password text form, takes the form name as a parameter.
class PasswordForm extends StatefulWidget {
  final String formName;
  String enteredPassword = "";
  PasswordForm(this.formName, {super.key});

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  bool showText = false;
  

  void getPassword(String value){
        setState(() {
          widget.enteredPassword = value;
        });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
