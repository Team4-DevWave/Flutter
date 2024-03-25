import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_app/features/user_system/view_model/auth_repository.dart';

final authControllerProvider = Provider(
  (ref) => AuthController(
    authRepository: ref.read(authRepositoryProvider),
  ),
);

class AuthController {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  void signInWithGoogle() {
    _authRepository.signInWithGoogle();
  }

  void signOutWithGoogle() {
    _authRepository.signOutGoogle();
  }
}