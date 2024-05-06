import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/firebase_providers.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    ref,
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final Ref ref;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(
    this.ref, {
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _googleSignIn = googleSignIn;

  Future<String?> signInWithGoogle() async {
    try {
      //UserCredential userCredential;

      if (await _googleSignIn.isSignedIn()) {
        _googleSignIn.signOut();
        _auth.signOut();
      }
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // userCredential = await _auth.signInWithCredential(credential);
      return (credential.accessToken);
    } on FirebaseException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  void logOut() async {
    deleteToken();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
