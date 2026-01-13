// sign_up.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sign_in.dart';
import 'GoogleSinIn.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SignUpScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const SignUpScreen({super.key, required this.onToggleTheme});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  final confirm = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  bool _isLoading = false;

  // Use the local isDark variable and widget.onToggleTheme instead

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _topBar(context, isDark, widget.onToggleTheme),
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
                    "Create account",
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
                    pass,
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
                  const SizedBox(height: 16),
                  _field(
                    "Confirm Password",
                    confirm,
                    isDark,
                    obscure: _obscureConfirm,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirm = !_obscureConfirm;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 22),
                  _primaryButton("Sign Up", () async {
                    final emailText = email.text.trim();
                    final passText = pass.text.trim();
                    final confirmText = confirm.text.trim();

                    if (emailText.isEmpty ||
                        passText.isEmpty ||
                        confirmText.isEmpty) {
                      _showSnack(context, 'All fields are required');
                      return;
                    }
                    if (passText != confirmText) {
                      _showSnack(context, 'Passwords do not match');
                      return;
                    }

                    setState(() => _isLoading = true);
                    try {
                      final userCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                            email: emailText,
                            password: passText,
                          );
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userCredential.user!.uid)
                          .set({'role': 'user', 'email': emailText});
                      await userCredential.user!.sendEmailVerification();
                      if (!mounted) return;
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Verify your email'),
                          content: const Text(
                            'A verification link has been sent to your email. Please verify your email before logging in.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SignInScreen(onToggleTheme: widget.onToggleTheme),
                        ),
                      );
                    } on FirebaseAuthException catch (e) {
                      final msg = e.message ?? 'Registration failed';
                      _showSnack(context, msg);
                    } catch (_) {
                      _showSnack(context, 'Registration failed');
                    } finally {
                      if (mounted) setState(() => _isLoading = false);
                    }
                  }, isLoading: _isLoading),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(
    BuildContext context,
    bool isDark,
    VoidCallback onToggleTheme,
  ) {
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
            onPressed: onToggleTheme,
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

Widget _primaryButton(
  String label,
  VoidCallback onPressed, {
  bool isLoading = false,
}) => ElevatedButton(
  onPressed: isLoading ? null : onPressed,
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFFF4D2D),
    minimumSize: const Size(double.infinity, 48),
  ),
  child: isLoading
      ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        )
      : Text(label),
);

void _showSnack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
