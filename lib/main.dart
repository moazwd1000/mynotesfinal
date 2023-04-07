import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotesfinal/views/login_view.dart';
import 'package:mynotesfinal/views/registor_view.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    routes: {
      // "/" : (context) => ,
      "/login/": (context) => const LoginView(),
      "/register/": (context) => const RegistorView(),
    },
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case (ConnectionState.done):
            // final user = FirebaseAuth.instance.currentUser;
            // if (user!.emailVerified) {
            // } else {
            //   print("not verified");
            //   return const EmailVerifyView();
            // }
            // return Text("Done");
            return LoginView();
          default:
            // ignore: prefer_const_constructors
            return CircularProgressIndicator();
        }
      },
    );
  }
}
