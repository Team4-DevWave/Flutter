import 'dart:io';

import 'package:flutter/material.dart';
import 'package:threddit_app/features/home_page/view/home_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_app/features/user_system/view/screens/register_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:window_manager/window_manager.dart';

final redditTheme = ThemeData().copyWith(
    scaffoldBackgroundColor: AppColors.backgroundColor,
    appBarTheme: const AppBarTheme().copyWith(
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: Colors.white.withOpacity(0.5)));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (Platform.isWindows) {
    WindowManager.instance.setMinimumSize(const Size(690, 500));
  }
  runApp(const ProviderScope(
    child: App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: redditTheme,
            home: const RegisterScreen(),
          );
        });
  }
}
