// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:threddit_app/features/notifications/view_model/methods.dart';
// import 'package:http/http.dart' as http;

// class testScreen extends StatefulWidget {
//   const testScreen({super.key});

//   @override
//   State<testScreen> createState() => _testScreenState();
// }

// class _testScreenState extends State<testScreen> {
//   String? mtoken = " ";
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   TextEditingController username = TextEditingController();
//   TextEditingController title = TextEditingController();
//   TextEditingController body = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     requestPermisseion();
//     getToken();
//     initInfo();
//   }

//   //remeber to try to make it aync and initialize to await
//   //@mipmap/ic_launcher icon of notification
//   //for background we need to modifed littte bit
//   initInfo() {
//     var androidInitialize =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     //var iOSInitialize=const IOSInitializationSettings();
//     var initializationSetting =
//         InitializationSettings(android: androidInitialize);
//     flutterLocalNotificationsPlugin.initialize(initializationSetting,
//         onDidReceiveNotificationResponse:
//             (NotificationResponse notificationResponse) async {
//       try {
//         if (notificationResponse.payload != null &&
//             notificationResponse.payload!.isNotEmpty) {}
//         // ignore: empty_catches
//       } catch (e) {}
//     });

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       print(
//           "=================================onMessage=======================");
//       print(
//           "onMessage : ${message.notification?.title} ${message.notification?.body}");

//       BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
//           message.notification!.body.toString(),
//           htmlFormatBigText: true,
//           contentTitle: message.notification!.title.toString(),
//           htmlFormatContentTitle: true);
//       AndroidNotificationDetails androidPlatformChannelSpecifics =
//           AndroidNotificationDetails('Ahmed', 'channelName',
//               importance: Importance.high,
//               styleInformation: bigTextStyleInformation,
//               priority: Priority.high,
//               playSound: true);
//       NotificationDetails platformChannelSpecifics =
//           NotificationDetails(android: androidPlatformChannelSpecifics);
//       await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
//           message.notification?.body, platformChannelSpecifics,
//           payload: message.data['body']);
//     });
//   }

//   void getToken() async {
//     await FirebaseMessaging.instance.getToken().then((value) {
//       setState(() {
//         mtoken = value;
//         print("My token is $mtoken");
//       });
//       saveToken(value!);
//     });
//   }

//   void saveToken(String token) async {
//     await FirebaseFirestore.instance.collection("UserTokens").doc("User3").set({
//       'token': token,
//     });
//   }

//   void sendPushNotification(String token, String body, String title) async {
//     try {
//       await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
//           headers: <String, String>{
//             'content-type': 'application/json',
//             'Authorization':
//                 'key=AAAAcq4OPFk:APA91bH5-K3x3Z9iCA1JAbGiJ6GMcYUiKEZAwT4Bz26W7bIJIHHNqMs3QsARuZDjOnlchh02Urm8EpYjygA-89qAzElIWzhhL5Y3cLI7HqSdEpP3vSpzbLWT0oQoJKQKdlMr6O1S3xD1'
//           },
//           body: jsonEncode(<String, dynamic>{
//             'priority': 'high',
//             'data': <String, dynamic>{
//               'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//               'status': 'done',
//               //payload
//               'body': body,
//               'title': title
//             },
//             "notification": <String, dynamic>{
//               "title": title,
//               "body": body,
//               "android_channel_id": "threddit_app"
//             },
//             "to": token,
//           }));
//       // ignore: empty_catches
//     } catch (e) {}
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//             body: Center(
//       child: Column(
//         children: [
//           TextFormField(
//             controller: username,
//           ),
//           TextFormField(
//             controller: title,
//           ),
//           TextFormField(
//             controller: body,
//           ),
//           GestureDetector(
//             onTap: () async {
//               String name = username.text.trim();
//               String titletext = title.text;
//               String bodytext = body.text;

//               if (name.isNotEmpty) {
//                 DocumentSnapshot snap = await FirebaseFirestore.instance
//                     .collection("UserTokens")
//                     .doc(name)
//                     .get();
//                 String token = snap["token"];
//                 print(token);
//                 //Send notification
//                 sendPushNotification(token, bodytext, titletext);
//               }
//             },
//             child: Container(
//                 margin: const EdgeInsets.all(20),
//                 height: 40,
//                 width: 200,
//                 decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(color: Colors.redAccent.withOpacity(0.5))
//                     ]),
//                 child: const Center(
//                   child: Text("Submit"),
//                 )),
//           )
//         ],
//       ),
//     )));
//   }
// }
