import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/firebase_providers.dart';

final googleAuth = Provider(
  (ref) => GoogleAuth(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class GoogleAuth {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  GoogleAuth({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      //return userCredential;

      print(userCredential.user?.email);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOutWithGoogle() async {
    try {
      //final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      //final googleAuth = await googleUser?.authentication;

      _googleSignIn.signOut();
      _auth.signOut();

      //return userCredential;

      // print(userCredential.user?.email);
    } catch (e) {
      print(e);
    }
  }
}
