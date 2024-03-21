import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/features/user_system/view/screens/register_screen.dart';
import 'package:threddit_app/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // designSize: const Size(360, 690),
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
