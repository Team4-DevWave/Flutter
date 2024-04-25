import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/notifications/view_model/methods.dart';
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
  String? mtoken = " ";
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();
    requestPermisseion();
    getToken();
    initInfo();
  }

  //remeber to try to make it aync and initialize to await
  //@mipmap/ic_launcher icon of notification
  // for background we need to modifed littte bit
  initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    //var iOSInitialize=const IOSInitializationSettings();
    var initializationSetting =
        InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      try {
        if (notificationResponse.payload != null &&
            notificationResponse.payload!.isNotEmpty) {}
        // ignore: empty_catches
      } catch (e) {}
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true);
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('Ahmed', 'channelName',
              importance: Importance.high,
              styleInformation: bigTextStyleInformation,
              priority: Priority.high,
              playSound: true);
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['body']);
    });
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        mtoken = value;
      });
      saveToken(value!);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection("UserTokens").doc("User5").set({
      'token': token,
    });
  }

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
