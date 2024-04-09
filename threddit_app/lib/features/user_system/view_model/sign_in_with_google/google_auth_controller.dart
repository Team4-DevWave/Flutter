import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/app/route.dart';
// import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/user_system/model/user_data.dart';
// import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
// import 'package:threddit_clone/features/user_system/model/type_defs.dart';
import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/google_auth.dart';
import 'package:threddit_clone/features/user_system/view_model/user_system_providers.dart';
// import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';

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

  Future<User?> signInWithGoogle() async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    return user;
  }

  void logout() async {
    deleteToken();
    deleteGoogleToken();
    _authRepository.logOut();
    Navigator.pushReplacementNamed(
        navigatorKey.currentContext!, RouteClass.registerScreen);
  }

  void googleLogout() async {
    deleteGoogleToken();
    _authRepository.logOut();
    UserModel? currentUser = _ref.read(userProvider)!;
    UserModel updatedUser = currentUser.copyWith(isGoogle: false);
    _ref.read(userProvider.notifier).state = updatedUser;
  }
}
