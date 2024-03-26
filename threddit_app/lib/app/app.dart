import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/app/route.dart';
import 'package:threddit_app/features/community/view/community_screen.dart';
import 'package:threddit_app/features/community/view/create_community.dart';
import 'package:threddit_app/features/posting/data/data.dart';
import 'package:threddit_app/features/posting/view/screens/post_screen.dart';
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
        print("My token is $mtoken");
      });
      saveToken(value!);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection("UserTokens").doc("User4").set({
      'token': token,
    });
  }

  void sendPushNotification(String token, String body, String title) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'content-type': 'application/json',
            'Authorization':
                'key=AAAAcq4OPFk:APA91bH5-K3x3Z9iCA1JAbGiJ6GMcYUiKEZAwT4Bz26W7bIJIHHNqMs3QsARuZDjOnlchh02Urm8EpYjygA-89qAzElIWzhhL5Y3cLI7HqSdEpP3vSpzbLWT0oQoJKQKdlMr6O1S3xD1'
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              //payload
              'body': body,
              'title': title
            },
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "threddit_app"
            },
            "to": token,
          }));
      // ignore: empty_catches
    } catch (e) {}
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
          return MaterialApp(
            initialRoute: RouteClass.loginScreen,
            onGenerateRoute: RouteClass.generateRoute,
            debugShowCheckedModeBanner: false,
            theme: redditTheme,
            home: const CreateCommunity(uid:'user2'),
          );
        });
  }
}
