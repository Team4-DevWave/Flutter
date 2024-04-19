import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/user_system/model/user_data.dart';
import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/google_auth.dart';
import 'package:threddit_clone/features/user_system/view_model/user_system_providers.dart';

/// Provides the state of the authentication controller.
/// Tracks whether an authentication process is ongoing.
final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

/// Initializes the controller with the required dependencies.
/// Sets the initial authentication state to false (not authenticating).
class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false);

  /// Signs in the user using Google authentication.
  /// Returns the User object if successful, otherwise null.
  Future<String?> signInWithGoogle() async {
    state = true;
    final userToken = await _authRepository.signInWithGoogle();
    state = false;
    return userToken;
  }

  /// Logs the user out of the application.
  void logout() async {
    deleteToken();
    deleteGoogleToken();
    _authRepository.logOut();
    Navigator.pushReplacementNamed(
        navigatorKey.currentContext!, RouteClass.registerScreen);
  }

  /// Logs the user out of the application for connect with google.
  void googleLogout() async {
    deleteGoogleToken();
    _authRepository.logOut();
    UserModel? currentUser = _ref.read(userProvider)!;
    UserModel updatedUser = currentUser.copyWith(isGoogle: false);
    _ref.read(userProvider.notifier).state = updatedUser;
  }
}
