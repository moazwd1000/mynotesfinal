import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotesfinal/constants/routes.dart';

class EmailVerifyView extends StatefulWidget {
  const EmailVerifyView({super.key});

  @override
  State<EmailVerifyView> createState() => _EmailVerifyViewState();
}

class _EmailVerifyViewState extends State<EmailVerifyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Column(
        children: [
          const Text(
              "We have already send an Email Verification,please open it..."),
          const Text("If you have not recieved and email click here :"),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              child: const Text("Send email verification")),
          TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, kregistorRoute, (route) => false);
              },
              child: const Text("Restart"))
        ],
      ),
    );
  }
}
