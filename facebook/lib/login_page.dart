import 'package:facebook/main_tabs.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';
import 'design_system.dart';
import 'google_sign_in_helper.dart';
import 'home_page.dart';

class loginPage extends StatefulWidget {
  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainTabs()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email. Redirecting to signup...';
        setState(() {
          _errorMessage = message;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => signupPage()),
        );
        return;
      }
      switch (e.code) {
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'user-disabled':
          message = 'This user has been disabled.';
          break;
        case 'wrong-password':
          message = 'Incorrect password.';
          break;
        case 'invalid-credential':
          message = 'The supplied auth credential is incorrect or expired.';
          break;
        default:
          message = 'Login failed: ${e.message}';
      }
      setState(() {
        _errorMessage = message;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      setState(() {
        _errorMessage = 'Login failed: ${e.toString()}';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: ${e.toString()}')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FBColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              color: FBColors.blue,
              child: const Center(
                child: Icon(Icons.facebook, size: 80, color: FBColors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 40.0,
              ),
              child: Column(
                children: [
                  if (_errorMessage != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Phone or email',
                      hintStyle: TextStyle(color: FBColors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: FBColors.offWhite),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: FBColors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: FBColors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: FBColors.offWhite),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: FBColors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FBColors.blue,
                        foregroundColor: FBColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Log In',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () =>
                          GoogleSignInHelper.signInWithGoogleUI(context, () {}),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: FBColors.offWhite),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: FBColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: FBColors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Row(
                    children: [
                      Expanded(child: Divider(color: FBColors.offWhite)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'OR',
                          style: TextStyle(color: FBColors.grey),
                        ),
                      ),
                      Expanded(child: Divider(color: FBColors.offWhite)),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 200,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => signupPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FBColors.green,
                        foregroundColor: FBColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'Create New Account',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
}
