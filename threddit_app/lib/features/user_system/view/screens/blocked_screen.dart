import 'package:flutter/material.dart';
/// A placeholder screen that should show the accounts blocked by a user.
class BlockedScreen extends StatelessWidget{
  const BlockedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blocked accounts"),
      ),
    );
  }
}