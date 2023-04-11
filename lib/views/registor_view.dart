import 'package:flutter/material.dart';
import 'package:mynotesfinal/constants/routes.dart';
import 'package:mynotesfinal/services/auth/auth_exceptions.dart';
import 'package:mynotesfinal/services/auth/auth_services.dart';

import '../firebase_options.dart';
import '../utilites/show_error_dialog.dart';

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
                  await AuthService.firebase()
                      .createUser(email: email, password: password);

                  AuthService.firebase().sendEmailVerfication();

                  Navigator.of(context).pushNamed(kverifyEMailRoute);
                } on WeakPasswordAuthException {
                  showErorAlert(context, "WEAK PASSWORD");
                } on EmailAlreadyInUseAuthException {
                  showErorAlert(context, "EMAIL ALREADY IN USE");
                } on InvalidEmailAuthException {
                  showErorAlert(context, "INVALID EMAIL");
                } on GenericAuthException {
                  showErorAlert(context, "Failed");
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
