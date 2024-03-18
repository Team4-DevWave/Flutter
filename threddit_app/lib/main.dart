import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_app/features/home_page/view/screens/main_screen_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/features/user_system/view/screens/account_settings_screen.dart';
import 'package:threddit_app/theme/colors.dart';

import 'package:flutter/services.dart';
import 'package:threddit_app/features/home_page/view/screens/home_screen.dart';
import 'package:threddit_app/app/app.dart';
import 'package:window_manager/window_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  if (Platform.isWindows) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    WindowManager.instance.setMinimumSize(const Size(690, 500));
  }


  runApp(const ProviderScope(child: App()));
}


