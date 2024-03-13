import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:threddit_app/features/home_page/view/home_screen.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_app/app.dart';
import 'package:window_manager/window_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //Limit the window minimization
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    WindowManager.instance.setMinimumSize(const Size(690, 500));
  }

  //Locking mobile to portraitUp
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) {
    //Call app class to start the app
    runApp(const ProviderScope(
      child: App(),
    ));
  });
}
