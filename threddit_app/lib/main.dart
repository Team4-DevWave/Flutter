import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:threddit_app/app/app.dart';
import 'package:threddit_app/firebase_options.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:window_manager/window_manager.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

// final redditTheme = ThemeData().copyWith(
//     scaffoldBackgroundColor: AppColors.backgroundColor,
//     appBarTheme: const AppBarTheme().copyWith(
//         backgroundColor: AppColors.backgroundColor,
//         foregroundColor: Colors.white.withOpacity(0.5)),
//     splashFactory: InkRipple.splashFactory);
// Future<void> _firebaseMessageingBackgroundHandler(RemoteMessage message) async {
//   print("handling a background message ${message.messageId}");
// }

// void main() async {

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
