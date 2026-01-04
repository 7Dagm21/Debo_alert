import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
import 'admin_home_page.dart';

Future<void> signInWithGoogle(
  BuildContext context,
  VoidCallback onToggleTheme,
) async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
        .authenticate();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final idToken = googleAuth.idToken;
    final credential = GoogleAuthProvider.credential(
      idToken: idToken,
    );
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // Check if Firestore user document exists, if not create with default role
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();
    if (!doc.exists) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'role': 'user', 'email': userCredential.user!.email});
    }

    // Route based on role
    final role =
        (await FirebaseFirestore.instance
                .collection('users')
                .doc(userCredential.user!.uid)
                .get())
            .data()?['role'] ??
        'user';
    if (role == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminHomePage(onToggleTheme: onToggleTheme),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(onToggleTheme: onToggleTheme),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Google sign-in failed')));
  }
}
