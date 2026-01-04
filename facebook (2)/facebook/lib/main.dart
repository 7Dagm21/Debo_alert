import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';
import 'signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const homePage(),
        '/login': (context) =>loginPage(),
        '/signup': (context) =>signupPage(),
      },
      home:Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 150,
                height:150,
                color: Colors.green,
              ),
              Builder(
                builder: 
                  (buttonContext) => ElevatedButton(
                    child: const Text('Start'),
                    onPressed: () {
                    Navigator.pushNamed(buttonContext, '/login');
                  },
                  
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
