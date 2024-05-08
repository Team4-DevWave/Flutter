import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';
import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/firebase_providers.dart';
import 'package:http/http.dart' as http;

///This provider controlls tha class of the [AuthRepository] which has the google
///functions and authentication
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    ref,
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

///[AuthRepository] a class that has the implemntation of the google fucntions needed for authentciation
///and signing the user in or out
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

  ///This function asume that there were a user before need to be singed out firstly
  ///so, first of all  [_googleSignIn] is responsible for call the google build in functions.
  ///
  ///The user is signed out by calling the sign out function.
  ///
  ///Then, sign in function is called, this function opens a pop up window to enable
  ///the user choose his preferd google account.
  ///
  ///At the end the end the user is authenticated with google using [GoogleAuthProvider]
  ///and the  access token is returned at the end of the [signInWithGoogle] fucntion.
  Future<String?> signInWithGoogle() async {
    try {
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

      return (credential.accessToken);
    } on FirebaseException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  ///This [logOut] fucntion uses the [deleteToken], which delete the user
  ///authenticated token while logging out.
  ///
  ///Uses [_googleSignIn] to call the built in sign out function that sign the google account out
  FutureEither<bool> logOut() async {
    final url = Uri.parse('https://www.threadit.tech/api/v1/users/me/signout');
    final token = await getToken();
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        await _googleSignIn.signOut();
        await _auth.signOut();
        deleteToken();
        deleteGoogleToken();
        return right(true);
      } else if (response.statusCode == 404) {
        return left(Failure('Something went wrong, try again later'));
      } else {
        return left(Failure('Something went wrong, try again later'));
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    }
  }
}
