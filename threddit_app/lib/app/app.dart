import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/app/route.dart';
import 'package:threddit_app/features/user_system/view/screens/username_screen.dart';

import 'package:threddit_app/theme/theme.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:threddit_app/features/notifications/view_model/methods.dart';
import 'package:http/http.dart' as http;

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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

  /// Initializes the notification system with the necessary settings.
  ///
  /// This method sets up the notification system with platform-specific settings
  /// such as icons and notification styles. It also handles incoming messages
  /// from Firebase Cloud Messaging (FCM) and displays them as local notifications.
  ///
  /// @mipmap/ic_launcher is used as the icon for notifications on Android.
  /// For iOS initialization, additional modifications may be required.
  ///
  /// Note: This method is asynchronous, and it is recommended to await its
  /// completion before proceeding with other tasks.
  ///
  /// Example:
  /// ```dart
  /// await initInfo();
  /// ```
  ///
  /// Throws:
  ///   - [Exception] if there's an error during initialization.
  ///
  //remeber to try to make it aync and initialize to await
  //@mipmap/ic_launcher icon of notification
  //for background we need to modifed littte bit
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
        // ignore: empty_catches, avoid_catches_without_on_clauses
      } catch (e) {}
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true);
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'Ahmed',
        'channelName',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
      );
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['body']);
    });
  }

  /// Retrieves the Firebase Cloud Messaging (FCM) token.
  ///
  /// This method asynchronously retrieves the FCM token and updates the state
  /// with the received token value. Additionally, it saves the token value
  /// for future reference.
  ///
  /// Example:
  /// ```dart
  /// await getToken();
  /// ```
  ///
  /// Throws:
  ///   - [FirebaseException] if there's an error while retrieving the token.
  ///
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        mtoken = value;
      });
      saveToken(value!);
    });
  }

  /// Saves the Firebase Cloud Messaging (FCM) token to Firestore.
  ///
  /// This method asynchronously saves the provided FCM token to Firestore
  /// under the collection "UserTokens" with the document ID "User4".
  ///
  /// Parameters:
  ///   - token: The FCM token to be saved.
  ///
  /// Example:
  /// ```dart
  /// await saveToken("your_token_here");
  /// ```
  ///
  /// Throws:
  ///   - [FirebaseException] if there's an error while saving the token to Firestore.
  ///
  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection("UserTokens").doc("User4").set({
      'token': token,
    });
  }

  @override
  Widget build(BuildContext context) {
    //Using screen responsive and adaptability package "ScreenUtil"
    return ScreenUtilInit(
        designSize: const Size(360, 690), //default size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          //App render start point
          return GestureDetector(
            onTap: () {
              // Ensure that you're unfocusing the correct FocusScope
              final currentFocus = FocusManager.instance.primaryFocus;
              if (currentFocus != null) {
                currentFocus.unfocus();
              }
            },
            child: MaterialApp(
              initialRoute: RouteClass.initRoute,
              onGenerateRoute: RouteClass.generateRoute,
              debugShowCheckedModeBanner: false,
              theme: redditTheme,
            ),
          );
        });
  }
}
