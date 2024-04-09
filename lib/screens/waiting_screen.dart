import 'package:flutter/material.dart';
import 'package:seller/screens/login_screen.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});

  static const String id = 'waiting-screen';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'PLEASE WAIT FOR THE ADMIN TO ACTIVATE YOUR ACCOUNT',
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, LoginScreen.id);
            },
            child: const Text(
              'Close',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
