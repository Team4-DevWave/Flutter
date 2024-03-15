import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/features/posting/view/screens/post_screen.dart';
import 'package:threddit_app/features/user_system/view/screens/register_screen.dart';
import 'package:threddit_app/theme/theme.dart';
import 'package:http/http.dart' as http;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final url = Uri.https(
        'flutter-prep-c61f6-default-rtdb.firebaseio.com', 'test.json');

    http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {'name': 'Mario', 'age': '23', 'hobby': 'Music'},
      ),
    );

    //Using screen responsive and adaptability package "ScreenUtil"
    return ScreenUtilInit(
        designSize: const Size(360, 690), //default size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          //App render start point
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: redditTheme,
            home: const PostScreen(),
          );
        });
  }
}
