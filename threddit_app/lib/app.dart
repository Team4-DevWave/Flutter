import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/features/user_system/view/screens/register_screen.dart';
import 'package:threddit_app/theme/theme.dart';
import 'package:http/http.dart' as http;

class App extends StatelessWidget {
  const App({Key? key});

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

    return ScreenUtilInit(
      designSize: const Size(360, 690), //default size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            // Ensure that you're unfocusing the correct FocusScope
            final currentFocus = FocusManager.instance.primaryFocus;
            if (currentFocus != null) {
              currentFocus.unfocus();
            }
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: redditTheme,
            home: const RegisterScreen(),
          ),
        );
      },
    );
  }
}
