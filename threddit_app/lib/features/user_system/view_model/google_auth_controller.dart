import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/user_system/view_model/google_auth.dart';

final authControllerProvider =
    Provider((ref) => AuthController(auth: ref.read(googleAuth)));

class AuthController {
  final GoogleAuth _auth;
  AuthController({required GoogleAuth auth}) : _auth = auth;

  void signInWithGoogle() {
    _auth.signInWithGoogle();
  }
}
