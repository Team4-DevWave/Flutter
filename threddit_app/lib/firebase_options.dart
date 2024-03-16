// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDM_39s59IOINF7zrI1TnVaNVPqeEwThcw',
    appId: '1:1050902103954:web:814abddab4f0d73a80e34b',
    messagingSenderId: '1050902103954',
    projectId: 'threddit-app',
    authDomain: 'threddit-app.firebaseapp.com',
    storageBucket: 'threddit-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCjG0k8MbVS_BJj2-0n8MXMgdits9pzqY0',
    appId: '1:1050902103954:android:768d7e1ce7eb186380e34b',
    messagingSenderId: '1050902103954',
    projectId: 'threddit-app',
    storageBucket: 'threddit-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBWPqAXlaFWIOxPYEwndQQl5b4InJsKYTo',
    appId: '1:1050902103954:ios:9fce3bbf561f44c180e34b',
    messagingSenderId: '1050902103954',
    projectId: 'threddit-app',
    storageBucket: 'threddit-app.appspot.com',
    iosBundleId: 'com.example.thredditApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBWPqAXlaFWIOxPYEwndQQl5b4InJsKYTo',
    appId: '1:1050902103954:ios:9232d721c52206d380e34b',
    messagingSenderId: '1050902103954',
    projectId: 'threddit-app',
    storageBucket: 'threddit-app.appspot.com',
    iosBundleId: 'com.example.thredditApp.RunnerTests',
  );
}