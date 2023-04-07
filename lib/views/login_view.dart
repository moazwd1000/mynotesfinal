import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

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
      body: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case (ConnectionState.done):
              return Column(
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
                    decoration:
                        InputDecoration(hintText: "Enter your password"),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        final email = _emailController.text;
                        final password = _passwordController.text;
                        try {
                          final userCredential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);
                          print(userCredential);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == "user-not-found") {
                            print("USER NOT FOUND");
                          } else if (e.code == "wrong-password") {
                            print("WRONG PASSWORD");
                          }
                        } catch (e) {}
                      },
                      child: const Text("Login"),
                    ),
                  ),
                ],
              );
            default:
              // ignore: prefer_const_constructors
              return Center(child: const Text("Loading....."));
          }
        },
      ),
    );
  }
}
