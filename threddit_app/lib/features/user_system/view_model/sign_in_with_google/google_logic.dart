import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/google_auth_controller.dart';

final user = Provider((ref) => const SignIn(
      user: {},
    ));

class SignIn {
  final _user;
  const SignIn({required user}) : _user = user;

  void googleSignInOnPressed(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider).signInWithGoogle();
    //send here this token using api

    //check if user exits in Backend
    //if so move to homepage

    //if not move to genderscreen
  }
}
