import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotesfinal/constants/routes.dart';
import 'package:mynotesfinal/services/auth/auth_services.dart';
import 'package:mynotesfinal/services/auth/bloc/auth_bloc.dart';
import 'package:mynotesfinal/services/auth/bloc/auth_events.dart';
import 'package:mynotesfinal/services/auth/bloc/auth_state.dart';
import 'package:mynotesfinal/services/auth/firebase_auth_provider.dart';
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
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: HomePage(),
      ),
      routes: {
        // kloginRoute: (context) => const LoginView(),
        // kregistorRoute: (context) => const RegistorView(),
        // knotesRoute: (context) => const NotesView(),
        // kverifyEMailRoute: (context) => const EmailVerifyView(),
        knewNoteROute: (context) => const CreateUpdateNotesView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return const NotesView();
      } else if (state is AuthStateNeedsVerification) {
        return const EmailVerifyView();
      } else if (state is AuthStateLoggedOut) {
        return const LoginView();
      } else if (state is AuthStateRegistering) {
        return const RegistorView();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });
  }
}
