import 'package:flutter_test/flutter_test.dart';
import 'package:mynotesfinal/services/auth/auth_exceptions.dart';
import 'package:mynotesfinal/services/auth/auth_provider.dart';
import 'package:mynotesfinal/services/auth/auth_user.dart';

void main() {
  group("Mock Authentication", () {
    final provider = MockAuthProvider();
    test("Should not be initialized at the start", () {
      expect(provider._isInitialized, false);
    });
    test("Cannot log out if not initialized", () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });
    test("Should be able to initialized", () async {
      await provider.initialize();
      expect(provider.isInitalized, true);
    });
    test("User Should be null after initialization", () async {
      expect(provider.currentUser, null);
    });
    test(
      "Should initialise in less than 2 seconds",
      () async {
        await provider.initialize();
        expect(provider.isInitalized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test("Create user -login function", () async {
      final badEmailUser =
          provider.createUser(email: "foo@bar.com", password: "AnyPassword");
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final badPasswordUser =
          provider.createUser(email: "someOne@bar.com", password: "foobar");
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));
      final user = await provider.createUser(email: "foo", password: "bar");
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test("Logged In user should be able to get verifies", () {
      provider.sendEmailVerfication();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test("Should be able to log out and log in again", () async {
      await provider.logOut();
      await provider.logIn(email: "email", password: "password");
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  bool _isInitialized = false;
  bool get isInitalized => _isInitialized;
  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    if (!isInitalized) throw NotInitializedException();
    await Future.delayed(Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitalized) throw NotInitializedException();
    if (email == "foo@bar.com") throw UserNotFoundAuthException();
    if (password == "foobar") throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false, email: 'foo@bar.com');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitalized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerfication() async {
    if (!isInitalized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true, email: 'foo@bar.com');
    _user = newUser;
  }
}
