import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotesfinal/services/auth/bloc/auth_bloc.dart';
import 'package:mynotesfinal/services/auth/bloc/auth_events.dart';
import 'package:mynotesfinal/services/auth/bloc/auth_state.dart';
import 'package:mynotesfinal/utilites/dialog/error_dialog.dart';
import 'package:mynotesfinal/utilites/dialog/password_reset_email_send_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            controller.clear();
            await showPasswordResetEmailSendDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(context,
                "Could not process your request, Make sure you are a registered user");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Forgot Text"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                  "Could not process your request, Make sure you are a registered user"),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                controller: controller,
                decoration: InputDecoration(hintText: "Your Email Adress"),
              ),
              TextButton(
                  onPressed: () {
                    final email = controller.text;
                    context
                        .read<AuthBloc>()
                        .add(AuthEventForgotPassword(email: email));
                  },
                  child: const Text("Reset Password Link")),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  child: const Text("Back to login Page")),
            ],
          ),
        ),
      ),
    );
  }
}
