import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/user_system/view/screens/text_size_screen.dart';
import 'package:threddit_clone/theme/theme.dart';

/// The `app.dart` file defines the `App` widget which is the root widget of the application.
/// It uses the `ScreenUtilInit` widget for responsive design and adaptability across different
/// screen sizes.

/// The `GestureDetector` widget is used to unfocus any text fields when the user taps outside
/// of them.

/// The `MaterialApp` widget is where the application starts rendering. It uses the `navigatorKey`
/// for navigation, `RouteClass.initRoute` as the initial route, and `RouteClass.generateRoute`
/// for route generation.

/// The `MediaQuery` widget is used to provide a `textScaler` to the rest of the widgets. This
/// `textScaler` is used to adjust the text size based on the user's settings.

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  Widget build(BuildContext context) {
    // Using screen responsive and adaptability package "ScreenUtil"
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Default size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // App render start point
        return GestureDetector(
          onTap: () {
            // Ensure that you're unfocusing the correct FocusScope
            final currentFocus = FocusManager.instance.primaryFocus;
            if (currentFocus != null) {
              currentFocus.unfocus();
            }
          },
          child: MaterialApp(
            navigatorKey: navigatorKey,
            initialRoute: RouteClass.initRoute,
            onGenerateRoute: RouteClass.generateRoute,
            debugShowCheckedModeBanner: false,
            theme: redditTheme,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(ref.watch(sliderProvider))),
                child: child!,
              );
            },
          ),
        );
      },
    );
  }
}
