import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/app/route.dart';
import 'package:threddit_app/features/home_page/view/screens/home_screen.dart';
import 'package:threddit_app/features/posting/data/data.dart';
import 'package:threddit_app/features/posting/view/screens/post_screen.dart';
import 'package:threddit_app/features/user_system/view/screens/register_screen.dart';
import 'package:threddit_app/theme/theme.dart';
import 'package:http/http.dart' as http;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    //Using screen responsive and adaptability package "ScreenUtil"
    return ScreenUtilInit(
        designSize: const Size(360, 690), //default size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          //App render start point
          return MaterialApp(
            initialRoute: RouteClass.loginScreen,
            onGenerateRoute: RouteClass.generateRoute,
            debugShowCheckedModeBanner: false,
            theme: redditTheme,
            home: PostScreen(currentPost:posts[0]),
          );
        });
  }
}
