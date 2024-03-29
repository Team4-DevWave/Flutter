import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/user_system/model/user_data.dart';
import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/google_auth.dart';
import 'package:threddit_clone/features/user_system/view_model/utils.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    auth: ref.watch(googleAuth),
    ref: ref,
  ),
);
final authStateChangeProvider = StreamProvider(
  (ref) {
    final authController = ref.watch(authControllerProvider.notifier);
    return authController.authStateChange;
  },
);

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final GoogleAuth _auth;
  final Ref _ref;
  AuthController({required GoogleAuth auth, required Ref ref})
      : _auth = auth,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _auth.authStateChange;
  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _auth.signInWithGoogle();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) => _ref.read(userProvider.notifier).update(
            (state) => userModel,
          ),
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _auth.getUserData(uid);
  }

  void signOutWithGoogle() {
    _auth.signOutWithGoogle();
  }
}
