import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/user_system/model/user_data.dart';
import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/google_auth.dart';
import 'package:threddit_clone/features/user_system/view_model/user_system_providers.dart';
import 'package:threddit_clone/features/user_system/view_model/utils.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  // ignore: unused_field
  final Ref _ref;
  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
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
        ///If response upon login is 200 therfore user is found and we will login
        ///else we will continue signup
        if (response.statusCode == 200) {
          saveToken(response.body.toString());
          Navigator.pushNamedAndRemoveUntil(
            navigatorKey.currentContext!,
            RouteClass.mainLayoutScreen,
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.pushNamed(
              navigatorKey.currentContext!, RouteClass.aboutMeScreen);
        }
      },
    );
  }
  void connectWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
      (l) {
        showSnackBar(navigatorKey.currentContext!, l.message);
      },
      (response) {
        if(response.statusCode == 200){
          Navigator.pushNamed(context, RouteClass.confirmPasswordScreen);
          saveToken(response.body);
          UserModel? currentUser = _ref.read(userProvider)!;
          UserModel updatedUser = currentUser.copyWith(isGoogle: true);
          _ref.read(userProvider.notifier).state = updatedUser;
          
        }
      }
    );
  }
  void logout() async {
    deleteToken();
    _authRepository.logOut();
    Navigator.pushReplacementNamed(
        navigatorKey.currentContext!, RouteClass.registerScreen);
  }
  void googleLogout() async {
    deleteGoogleToken();
    _authRepository.logOut();    
    UserModel? currentUser = _ref.read(userProvider)!;
    UserModel updatedUser = currentUser.copyWith(isGoogle: false);
    _ref.read(userProvider.notifier).state = updatedUser;}
}
