import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotesfinal/constants/routes.dart';
import 'package:mynotesfinal/services/auth/auth_exceptions.dart';
import 'package:mynotesfinal/services/auth/auth_services.dart';
import 'package:mynotesfinal/services/auth/bloc/auth_events.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilites/dialog/error_dialog.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, "WEAK PASSWORD");
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, "EMAIL ALREADY IN USE");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Failed to registor");
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, "Invalid Email");
          }
        }
      },
      child: Scaffold(
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
                  context
                      .read<AuthBloc>()
                      .add(AuthEventRegistor(email, password));
                },
                child: const Text("Registor"),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthEventLogOut());
              },
              child: const Text("Too Login.."),
            )
          ],
        ),
      ),
    );
  }
}
