import 'package:flutter/material.dart';

class CommunityModTools extends StatefulWidget {
  const CommunityModTools({super.key});
  @override
  State<CommunityModTools> createState() => _CommunityModToolsState();
}

class _CommunityModToolsState extends State<CommunityModTools> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true, title: const Text('Mod Tools')),
      //body: Text('This is the mod tools screen', style: TextStyle(color: Colors.white),),
    );
  }
}
