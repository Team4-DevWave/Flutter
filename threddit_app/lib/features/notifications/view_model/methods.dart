import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
