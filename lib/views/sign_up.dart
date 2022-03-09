import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_calendar/services/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../main.dart';

// TODO:
//      form validation

class SignUp extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Email",
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
                labelText: "Password"
            ),
          ),
          ElevatedButton(onPressed: () {
            context.read<AuthService>().signUp(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AuthWrapper()),
            );
          },
              child: Text("Sign Up"))
        ],
      ),
    );
  }

}