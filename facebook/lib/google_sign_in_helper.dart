import 'package:flutter/material.dart';
import 'design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main_tabs.dart';

class GoogleSignInHelper {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId:
        '604234550060-2mtgage7906se7vap3s5n4emmmfufffh.apps.googleusercontent.com',
  );

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Always sign out first to force account picker
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        // Always sign out Google after sign-in to force picker next time
        await _googleSignIn.signOut();
        return userCredential;
      } on FirebaseAuthException catch (e) {
        await _googleSignIn.signOut();
        if (e.code == 'user-not-found' || e.code == 'account-exists-with-different-credential') {
          // User does not exist or wrong provider
          return null;
        } else if (e.code == 'invalid-credential') {
          print('Invalid Google credential.');
          return null;
        } else if (e.code == 'user-disabled') {
          print('User account is disabled.');
          return null;
        } else if (e.code == 'operation-not-allowed') {
          print('Operation not allowed.');
          return null;
        } else {
          print('Google Sign-In Error: ${e.code} - ${e.message}');
          return null;
        }
      }
    } catch (e) {
      print('Google Sign-In Error: $e');
      await _googleSignIn.signOut();
      return null;
    }
  }

  static Future<void> signInWithGoogleUI(
    BuildContext context,
    VoidCallback onToggleTheme,
  ) async {
    try {
      final userCredential = await signInWithGoogle();
      if (userCredential?.user != null) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (context) => MainTabs()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google account not found. Please sign up first.'),
          ),
        );
        // Sign out from Google if not allowed
        await _googleSignIn.signOut();
        await FirebaseAuth.instance.signOut();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during Google sign-in: $e')),
      );
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  static Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }
}
