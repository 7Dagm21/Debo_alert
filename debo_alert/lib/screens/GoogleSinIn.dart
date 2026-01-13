import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Add this import
import 'home.dart';
import 'admin_home_page.dart';

class GoogleSignInHelper {
  // Initialize GoogleSignIn based on platform
  static GoogleSignIn get _googleSignIn {
    if (kIsWeb) {
      // For web
      return GoogleSignIn.standard(scopes: ['email', 'profile']);
    } else {
      // For mobile (Android/iOS)
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
      );
      return googleSignIn;
    }
  }

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Step 1: Sign in with Google
      final googleSignIn = _googleSignIn;
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      // Step 2: Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final accessToken = googleAuth.accessToken; // <-- Google access token

      // Step 3: Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 4: Sign in with Firebase
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('Google Sign-In Error: $e');
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
        final user = userCredential!.user!;

        // Fetch admin status from backend (similar to email login)
        final idToken = await user.getIdToken(true);

        try {
          final apiUrl =
              dotenv.env['API_BASE_URL'] ??
              'http://localhost:5099'; // Use .env value
          final response = await http.get(
            Uri.parse('$apiUrl/api/users'), // Use apiUrl here
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $idToken',
            },
          );

          if (response.statusCode == 200) {
            final List<dynamic> users = json.decode(response.body);
            final userData = users.firstWhere(
              (u) => u['email'] == user.email,
              orElse: () => null,
            );

            if (userData != null && userData['isAdmin'] == true) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => AdminHomePage(onToggleTheme: onToggleTheme),
                ),
              );
              return;
            }
          }
        } catch (e) {
          print('Error checking admin status: $e');
        }

        // Default to user page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(onToggleTheme: onToggleTheme),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign-in failed or cancelled')),
        );
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
}
