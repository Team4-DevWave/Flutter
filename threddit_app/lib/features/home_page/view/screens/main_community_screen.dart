import 'package:flutter/material.dart';

class MainCommunityScreen extends StatefulWidget {
  const MainCommunityScreen({super.key});
  @override
  State<MainCommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<MainCommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, title: const Text('Community')),
      body: Text(
        'This is the community screen Exploring Community',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
