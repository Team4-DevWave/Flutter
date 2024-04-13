import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/home_page/view/screens/main_screen_layout.dart';
import 'package:threddit_clone/features/user_profile/models/user_model.dart';
import 'package:threddit_clone/features/user_profile/view_model/get_user.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view/screens/register_screen.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/theme/theme.dart';

class StartScreen extends ConsumerWidget {
  const StartScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(textSizeProvider.notifier).getFontOption();
    ref.watch(textSizeProvider.notifier).getTextSize();

    Future<String?> getUserData() async {
      await ref.read(settingsFetchProvider.notifier).getMe();
      return getToken();
    }

    return FutureBuilder<String?>(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final token = snapshot.data;
          if (token == null) {
            return const RegisterScreen();
          } else {
            print("Token");
            print(token);
            print("Token222");
            return const MainScreenLayout();
          }
        }
      },
    );
  }
}
