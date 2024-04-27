import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/token_storage.dart';

/// Requests permission for receiving notifications.
///
/// This method requests permission for receiving notifications from the user
/// using Firebase Cloud Messaging (FCM). It handles different permission
/// scenarios and prints corresponding messages.
///
/// Example:
/// ```dart
/// await requestPermission();
/// ```
///
void requestPermisseion() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true);
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("User Granted permissions");
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print("User Granted provisional permission");
  } else {
    print("User declined or has not accpet permission");
  }
}

/// Sends a push notification to the specified FCM token.
///
/// This method sends a push notification to the device corresponding to
/// the provided FCM token using Firebase Cloud Messaging (FCM).
///
/// Parameters:
///   - token: The FCM token of the recipient device.
///   - body: The body text of the notification.
///   - title: The title of the notification.
///
/// Example:
/// ```dart
/// await sendPushNotification("recipient_token", "Notification body", "Notification title");
/// ```
///
void sendPushNotification(String token, String body, String title) async {
  try {
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'content-type': 'application/json',
          'Authorization':
              // ignore: lines_longer_than_80_chars
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

Future<void> markAsRead(String id) async {
  String? token = await getToken();
  final response = await http.patch(
    Uri.parse(
      'http://10.0.2.2:8000/api/v1/notifications/read/$id',
    ),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to mark notification as read');
  }
}
