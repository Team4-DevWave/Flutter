import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:threddit_app/features/notifications/view/test_screen.dart';
import 'package:threddit_app/features/user_system/view/regisiter_screen.dart';
import 'package:threddit_app/firebase_options.dart';

Future<void> _firebaseMessageingBackgroundHandler(RemoteMessage message) async {
  print("handling a background message ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessageingBackgroundHandler);
  runApp(const testScreen());
}
