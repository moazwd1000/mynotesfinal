import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotesfinal/constants/routes.dart';
import 'package:mynotesfinal/services/auth/auth_exceptions.dart';
import 'package:mynotesfinal/services/auth/auth_services.dart';
import 'package:mynotesfinal/services/auth/bloc/auth_bloc.dart';
import 'package:mynotesfinal/services/auth/bloc/auth_events.dart';

import '../services/auth/bloc/auth_state.dart';
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
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) async {
                if (state is AuthStateLoggedOut) {
                  if (state.exception is UserNotFoundAuthException) {
                    await showErrorDialog(context, "USER NOT FOUND");
                  } else if (state.exception is WrongPasswordAuthException) {
                    await showErrorDialog(context, "Wrong Credentials");
                  } else if (state.exception is GenericAuthException) {
                    await showErrorDialog(context, "Authentication Error");
                  }
                }
              },
              child: TextButton(
                onPressed: () async {
                  final email = _emailController.text;
                  final password = _passwordController.text;
                  context.read<AuthBloc>().add(AuthEventLogIn(email, password));
                },
                child: const Text("Login"),
              ),
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
