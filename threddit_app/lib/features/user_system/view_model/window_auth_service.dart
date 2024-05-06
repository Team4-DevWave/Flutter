import 'package:firebase_auth/firebase_auth.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/view_model/window_auth_manager.dart';

///This function asume that there were a user before need to be singed out firstly
///so, first of all  [_authManager] is responsible for call the google build in functions.
///
///The user is signed out by calling the sign out function.
///
///Then, sign in function is called, this function opens a pop up window to enable
///the user choose his preferd google account.
///
///At the end the end the user is authenticated with google using [GoogleAuthProvider]
///and the  access token is returned at the end of the [signInWithGoogle] fucntion.
class AuthService {
  final _auth = FirebaseAuth.instance;
  final _authManager = AuthManager();

  Future<String?> signInWithGoogle() async {
    final credentials = await _authManager.login();
    final authCredential = GoogleAuthProvider.credential(
      idToken: credentials.idToken,
      accessToken: credentials.accessToken,
    );
    return authCredential.accessToken;
  }

  ///This [signOut] fucntion uses the [deleteToken], which delete the user
  ///authenticated token while logging out.
  ///
  ///Uses [_auth] to call the built in sign out function that sign the google account out
  Future<void> signOut() async {
    await deleteToken();
    await _auth.signOut();
  }
}
