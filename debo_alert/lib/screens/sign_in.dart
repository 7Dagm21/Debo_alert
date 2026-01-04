import 'package:flutter/material.dart';
import 'sign_up.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_home_page.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const SignInScreen({super.key, required this.onToggleTheme});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value);
  }

  void _login() async {
    final enteredEmail = email.text.trim();
    final enteredPassword = password.text;

    if (enteredEmail.isEmpty || enteredPassword.isEmpty) {
      _toast("All fields are required");
      return;
    }
    if (!_isValidEmail(enteredEmail)) {
      _toast("Enter a valid email");
      return;
    }
    if (enteredPassword.length < 6) {
      _toast("Password must be at least 6 characters");
      return;
    }
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: enteredEmail,
            password: enteredPassword,
          );
      if (!FirebaseAuth.instance.currentUser!.emailVerified) {
        _toast("Please verify your email before logging in.");
        await FirebaseAuth.instance.signOut();
        return;
      }
      // Print Firebase ID token for API testing
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final idToken = await user.getIdToken(true);
        // ignore: avoid_print
        print('=== COPY THIS TOKEN FOR API TESTING ===');
        // ignore: avoid_print
        print(idToken);
      }
      // Fetch role from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      final role = doc.data()?['role'] ?? 'user';
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AdminHomePage(onToggleTheme: widget.onToggleTheme),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(onToggleTheme: widget.onToggleTheme),
          ),
        );
      }
    } catch (e) {
      _toast("Invalid email or password");
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _topBar(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  const Icon(
                    Icons.notifications_active,
                    size: 60,
                    color: Color(0xFFFF4D2D),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    "Welcome back",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),

                  const SizedBox(height: 16),
                  _googleButton(isDark, context, widget.onToggleTheme),

                  const SizedBox(height: 26),
                  _field("Email", email, isDark),
                  const SizedBox(height: 16),
                  _field("Password", password, isDark, obscure: true),

                  const SizedBox(height: 22),
                  _primaryButton("Login", _login),

                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SignUpScreen(onToggleTheme: widget.onToggleTheme),
                      ),
                    ),
                    child: const Text(
                      "Create account",
                      style: TextStyle(color: Color(0xFFFF4D2D)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Positioned(
      top: 10,
      left: 10,
      right: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
    );
  }
}

Widget _googleButton(
  bool isDark,
  BuildContext context,
  VoidCallback onToggleTheme,
) => OutlinedButton.icon(
  onPressed: () {
    // TODO: Implement Google Sign-In functionality or import the correct file.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Sign-In not implemented.')),
    );
  },
  icon: const Icon(Icons.g_mobiledata, size: 28),
  label: const Text("Continue with Google"),
);

Widget _field(
  String label,
  TextEditingController c,
  bool isDark, {
  bool obscure = false,
}) => TextField(
  controller: c,
  obscureText: obscure,
  decoration: InputDecoration(
    labelText: label,
    filled: true,
    fillColor: isDark ? Colors.white12 : Colors.black12,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  ),
);

Widget _primaryButton(String label, VoidCallback onTap) => ElevatedButton(
  onPressed: onTap,
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFFF4D2D),
    minimumSize: const Size(double.infinity, 48),
  ),
  child: Text(label),
);

void printIdToken() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final idToken = await user.getIdToken(true); // true = force refresh
    print('=== COPY THIS TOKEN ===');
    print(idToken);
  } else {
    print('No user is currently signed in.');
  }
}
