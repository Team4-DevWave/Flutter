import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/home_page/view/screens/main_screen_layout.dart';
import 'package:threddit_clone/features/user_system/model/user_data.dart';
import 'package:threddit_clone/features/user_system/view/screens/register_screen.dart';
import 'package:threddit_clone/features/user_system/view_model/error_text.dart';
import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/google_auth_controller.dart';
import 'package:threddit_clone/theme/theme.dart';

class StartScreen extends ConsumerStatefulWidget {
  const StartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StartScreenState();
}

class _StartScreenState extends ConsumerState<StartScreen> {
  UserModel? userModel;
  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;

    ref.read(userProvider.notifier).update((state) => userModel);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
          data: (data) {
            if (data != null) {
              getData(ref, data);
              return const MainScreenLayout();
            }
            return const RegisterScreen();
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loading(),
        );
  }
}
