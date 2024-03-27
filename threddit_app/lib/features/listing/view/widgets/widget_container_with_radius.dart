import 'package:flutter/material.dart';

class AddRadiusBoarder extends StatelessWidget {
  Widget childWidget;
  AddRadiusBoarder({super.key, required this.childWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: childWidget,
    );
  }
}
