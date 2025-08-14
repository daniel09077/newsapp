import 'dart:async';
import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
    // Show intro for 2 seconds, then navigate to Decider
    Timer(const Duration(seconds: 2), _navigateNext);
  }

  void _navigateNext() {
    Navigator.pushReplacementNamed(context, '/decider');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Group 1.png', height: 150),
            const SizedBox(height: 32),
            const Text(
              'Welcome to the Kaduna Polytechnic News Portal',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 91, 168, 117),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
