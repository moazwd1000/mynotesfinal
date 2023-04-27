import 'package:bloc/bloc.dart';
import 'package:mynotesfinal/services/auth/auth_provider.dart';
import 'package:mynotesfinal/services/auth/bloc/auth_events.dart';
import 'package:mynotesfinal/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUnIniailaized(isLoading: true)) {
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sendEmailVerfication();
        emit(state);
      },
    );

    on<AuthEventRegistor>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;
        try {
          await provider.createUser(email: email, password: password);
          await provider.sendEmailVerfication();
          emit(AuthStateNeedsVerification(isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateRegistering(isLoading: false, exception: e));
        }
      },
    );

    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: true,
            Loadingtext: "Please wait while you are logged In"));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(isLoading: false, user: user));
      }
    });

    on<AuthEventLogIn>(
      (event, emit) async {
        emit(const AuthStateLoggedOut(exception: null, isLoading: true));
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.logIn(email: email, password: password);
          if (!user.isEmailVerified) {
            emit(const AuthStateLoggedOut(exception: null, isLoading: false));
            emit(const AuthStateNeedsVerification(isLoading: false));
          } else {
            emit(const AuthStateLoggedOut(exception: null, isLoading: false));
            emit(AuthStateLoggedIn(isLoading: false, user: user));
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          await provider.logOut();
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );
  }
}
