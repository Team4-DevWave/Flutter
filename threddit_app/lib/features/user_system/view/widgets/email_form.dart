import 'package:flutter/material.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// Creates an email form that takes the [String] as the form name.
// ignore: must_be_immutable
class EmailForm extends StatefulWidget {
  final String formName;
  String enteredEmail = "";
  EmailForm(this.formName, {super.key});

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
        style: AppTextStyles.primaryTextStyle,
        onChanged: getEmail,
        decoration: InputDecoration(
          labelText: widget.formName,
        ));
  }
}
