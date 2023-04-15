import 'package:flutter/material.dart';
import 'package:mynotesfinal/constants/routes.dart';
import 'package:mynotesfinal/services/auth/auth_exceptions.dart';
import 'package:mynotesfinal/services/auth/auth_services.dart';

import '../firebase_options.dart';
import '../utilites/dialog/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(
        title: const Text("Login"),
      ),
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
                  await AuthService.firebase()
                      .logIn(email: email, password: password);

                  final user = AuthService.firebase().currentUser;
                  if (!user!.isEmailVerified) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, kverifyEMailRoute, (route) => false);
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                        context, knotesRoute, (route) => false);
                  }
                } on UserNotFoundAuthException {
                  showErrorDialog(context, "USER NOT FOUND");
                } on WrongPasswordAuthException {
                  showErrorDialog(context, "WRONG PASSWORD");
                } on GenericAuthException {
                  showErrorDialog(context, "Authentication Error");
                }
              },
              child: const Text("Login"),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, kregistorRoute, (route) => false);
            },
            child: const Text("Not registered yet ? Press Here.."),
          )
        ],
      ),
    );
  }
}
