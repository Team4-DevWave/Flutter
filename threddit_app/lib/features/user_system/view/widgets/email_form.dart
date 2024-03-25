import 'package:flutter/material.dart';

class EmailForm extends StatefulWidget {
  final String formName;
  String enteredEmail = "";
  EmailForm(this.formName);

  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  void getEmail(String value) {
    setState(() {
      widget.enteredEmail = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onChanged: getEmail,
        decoration: InputDecoration(
          labelText: widget.formName,
        ));
  }
}
