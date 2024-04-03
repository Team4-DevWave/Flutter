import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/user_data.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/google_auth.dart';
import 'package:threddit_clone/features/user_system/view_model/utils.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;

  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        super(false);

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;

    user.fold(
      (l) {
        showSnackBar(navigatorKey.currentContext!, l.message);
      },
      (response) {
        if (response.statusCode == 200) {
          saveToken(response.body.toString());
          Navigator.pushReplacementNamed(
              navigatorKey.currentContext!, RouteClass.mainLayoutScreen);
        } else {
          Navigator.pushNamed(
              navigatorKey.currentContext!, RouteClass.aboutMeScreen);
        }
      },
    );
  }

  void logout() async {
    deleteToken();
    _authRepository.logOut();
    Navigator.pushReplacementNamed(
        navigatorKey.currentContext!, RouteClass.registerScreen);
  }
}
