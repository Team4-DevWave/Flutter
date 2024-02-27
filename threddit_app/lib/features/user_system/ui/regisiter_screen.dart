import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class registerScreen extends StatefulWidget {
  const registerScreen({super.key});

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(designSize: const Size(360, 690),builder: (context, child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home:Scaffold(
        backgroundColor: Color.fromARGB(255, 189, 110, 8),
        body: Text("Hello"),
      ),
    ),);
  }
}