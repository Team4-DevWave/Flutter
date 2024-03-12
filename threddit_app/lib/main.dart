import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_app/features/user_system/view/screens/login_screen.dart';
import 'package:threddit_app/features/user_system/view/screens/register_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/theme/colors.dart';

void main() {
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
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData().copyWith(
                scaffoldBackgroundColor: AppColors.backgroundColor,
                appBarTheme: const AppBarTheme().copyWith(
                    backgroundColor: AppColors.backgroundColor,
                    foregroundColor: Colors.white.withOpacity(0.5))),
            home: const RegisterScreen(),
          );
        });
  }
}
