import 'package:firebase_auth/firebase_auth.dart';
import 'package:threddit_clone/features/user_system/view_model/window_auth_manager.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _authManager = AuthManager();

  Future<User?> signInWithGoogle() async {
    final credentials = await _authManager.login();
    final authCredential = GoogleAuthProvider.credential(
      idToken: credentials.idToken,
      accessToken: credentials.accessToken,
    );
    final userCredential = await _auth.signInWithCredential(authCredential);
    return userCredential.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
