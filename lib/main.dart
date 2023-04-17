import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotesfinal/constants/routes.dart';
import 'package:mynotesfinal/services/auth/auth_services.dart';
import 'package:mynotesfinal/views/login_view.dart';
import 'package:mynotesfinal/views/notes/create_update_notes_view.dart';
import 'package:mynotesfinal/views/notes/notes_view.dart';

import 'package:mynotesfinal/views/registor_view.dart';
import 'package:mynotesfinal/views/verify_email.dart';
import 'package:path/path.dart';

import 'enums/menu_actions.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        kloginRoute: (context) => const LoginView(),
        kregistorRoute: (context) => const RegistorView(),
        knotesRoute: (context) => const NotesView(),
        kverifyEMailRoute: (context) => const EmailVerifyView(),
        knewNoteROute: (context) => const CreateUpdateNotesView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const EmailVerifyView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
