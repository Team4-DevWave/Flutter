import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:threddit_clone/app/app.dart';
import 'package:threddit_clone/firebase_options.dart';
import 'package:window_manager/window_manager.dart';

Future<void> _firebaseMessageingBackgroundHandler(RemoteMessage message) async {
  print("handling a background message ${message.messageId}");
}

void main() async {
  if (Platform.isWindows) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    WindowManager.instance.setMinimumSize(const Size(690, 500));
  } else {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessageingBackgroundHandler);
  }

  runApp(const ProviderScope(child: App()));
}
