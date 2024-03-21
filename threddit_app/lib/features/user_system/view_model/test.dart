import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthentication {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final String accessToken = googleAuth.accessToken!;
        final String idToken = googleAuth.idToken!;

        // You can now use accessToken and idToken for further processing
        // For example, you can send them to your backend server

        // Return the idToken (or accessToken) to the caller
        return idToken;
      } else {
        // User canceled the sign-in process
        return null;
      }
    } catch (error) {
      // Handle sign-in errors
      print('Error signing in with Google: $error');
      return null;
    }
  }

  void signOutGoogle() async {
    await _googleSignIn.signOut();
    print("User signed out from Google");
  }
}

class GoogleSignInButton extends StatelessWidget {
  final GoogleAuthentication googleAuth;

  const GoogleSignInButton({Key? key, required this.googleAuth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Initiate sign-in process when the button is pressed
        String? idToken = await googleAuth.signInWithGoogle();
        if (idToken != null) {
          // Successfully signed in with Google
          // Do something with the idToken (e.g., send it to your backend)
        } else {
          // User canceled the sign-in process
        }
      },
      child: Text('Sign in with Google'),
    );
  }
}
