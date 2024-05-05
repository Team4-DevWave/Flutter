import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

///[authProvider] is used to authenticate the user sign in with google on firebase
final authProvider = Provider((ref) => FirebaseAuth.instance);

///[googleSignInProvider] is used to create and object from the [GoogleSignIn] which is used
///to call the built in function that authenticate the user with google
final googleSignInProvider = Provider((ref) => GoogleSignIn());
