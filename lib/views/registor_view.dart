import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotesfinal/constants/routes.dart';

import '../firebase_options.dart';

class RegistorView extends StatefulWidget {
  const RegistorView({super.key});

  @override
  State<RegistorView> createState() => _RegistorViewState();
}

class _RegistorViewState extends State<RegistorView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registor")),
      body: Column(
        children: [
          TextField(
            enableSuggestions: false,
            autocorrect: true,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            decoration: InputDecoration(hintText: "Enter your Email"),
          ),
          TextField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: true,
            controller: _passwordController,
            decoration: InputDecoration(hintText: "Enter your password"),
          ),
          Center(
            child: TextButton(
              onPressed: () async {
                final email = _emailController.text;
                final password = _passwordController.text;
                try {
                  final userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password);
                  print(userCredential);
                } on FirebaseAuthException catch (e) {
                  if (e.code == "weak-password") {
                    print("WEAK PASSWORD");
                  } else if (e.code == "email-already-in-use") {
                    print("EMAIL ALREADY IN USE");
                  } else if (e.code == "invalid-email") {
                    print("INVALID EMAIL");
                  }
                }
              },
              child: const Text("Registor"),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, kloginRoute, (route) => false);
            },
            child: const Text("Too Login.."),
          )
        ],
      ),
    );
  }
}
