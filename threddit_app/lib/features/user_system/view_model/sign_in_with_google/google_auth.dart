// import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
// import 'package:threddit_clone/features/user_system/model/failure.dart';
// import 'package:threddit_clone/features/user_system/model/type_defs.dart';
// import 'package:threddit_clone/features/user_system/model/user_data.dart';
import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/firebase_providers.dart';
// import 'package:http/http.dart' as http;
// import 'package:threddit_clone/features/user_system/view_model/user_system_providers.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    ref,
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

///This class is responsible for google authentication
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

  Future<User?> signInWithGoogle() async {
    try {
      UserCredential userCredential;

      if (await _googleSignIn.isSignedIn()) {
        _googleSignIn.signOut();
        _auth.signOut();
      }
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      userCredential = await _auth.signInWithCredential(credential);

      return (userCredential.user);
    } on FirebaseException {
      rethrow;
      //throw e.message!;
    } catch (e) {
      rethrow;
      //return left(Failure(e.toString()));
    }
  }

  void logOut() async {
    deleteToken();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
