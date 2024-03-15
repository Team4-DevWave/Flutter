import 'package:flutter/material.dart';

class UpdateEmailScreen extends StatelessWidget {
  const UpdateEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Update email address"),
        actions: [TextButton(onPressed: () {}, child: Text("Save"))],
      ),
      
    );
  }
}
