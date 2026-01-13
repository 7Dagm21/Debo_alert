import 'package:flutter/material.dart';
import 'sign_up.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin_home_page.dart';
import 'GoogleSinIn.dart'; // Add this import at the top
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Add this import

class SignInScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const SignInScreen({super.key, required this.onToggleTheme});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  bool _obscurePassword = true;

  // Use API base URL from .env
  final String apiUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:5099';

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(value);
  }

  void _login() async {
    final enteredEmail = email.text.trim();
    final enteredPassword = password.text.trim();

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
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final idToken = await user.getIdToken(true);
        // ignore: avoid_print
        print('=== COPY THIS TOKEN FOR API TESTING ===');
        // ignore: avoid_print
        print(idToken);

        // Fetch admin status from backend
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
                builder: (_) =>
                    AdminHomePage(onToggleTheme: widget.onToggleTheme),
              ),
            );
            return;
          }
        }
        // Default to user page
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
              child: SingleChildScrollView(
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
                    _field(
                      "Password",
                      password,
                      isDark,
                      obscure: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
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
  onPressed: () =>
      GoogleSignInHelper.signInWithGoogleUI(context, onToggleTheme),
  icon: const Icon(Icons.g_mobiledata, size: 28),
  label: const Text("Continue with Google"),
);

Widget _field(
  String label,
  TextEditingController c,
  bool isDark, {
  bool obscure = false,
  Widget? suffixIcon,
}) => TextField(
  controller: c,
  obscureText: obscure,
  decoration: InputDecoration(
    labelText: label,
    filled: true,
    fillColor: isDark ? Colors.white12 : Colors.black12,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    suffixIcon: suffixIcon,
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
