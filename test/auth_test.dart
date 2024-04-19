import 'package:flutter_test/flutter_test.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';

void main() {

  group("mock auth", () {
    final provider = MockAuthProvider();

    test("should not be initialized to begin with", () => {
      expect(provider.isInitialised, false)
    });

    test("can not log out if not initialized", () => {
      expect(
          provider.logout(),
          throwsA(const TypeMatcher<NotInitializedException>()))
    });

    test("should be able to be initialized", () async {
      await provider.initialize();
      expect(provider.isInitialised, true);
    });

    test("User should be null after initialization", () {
      expect(provider.currentsUser, null);
    });
    
    test("should be able to initialise in less than 2 seconds", () async {
      await provider.initialize();
      expect(provider.isInitialised, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test("create user should delegate to login", () async {
      final badEmailUser = provider.createUser(
          email: "foo@bar.com", 
          password: "anypassword",
      );
      expect(badEmailUser, throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser = await provider.createUser(
          email: "someone@bar.com",
          password: "foobar",
      );
      expect(badPasswordUser, throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
          email: "foo",
          password: "bar",);
      expect(provider.currentsUser, user);
      expect(user.isEmailVerified, false);
    });
    
    test("logged in user should be able to get verified", () {
      provider.sendEmailVerification();
      final user = provider.currentsUser;
      expect(user, isNotNull);
      expect(user?.isEmailVerified, true);
    });

    test("should be able to logout and loin again", () async {
      await provider.logout();
      await provider.login(
          email: "email",
          password: "password",
      );
      final user = provider.currentsUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception{}

class MockAuthProvider implements AuthProvider{
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialised => _isInitialized;

  @override
  Future<AuthUser> createUser({required String email, required String password})
  async {
    if (!isInitialised) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return login(email: email, password: password);
  }

  @override
  AuthUser? get currentsUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> login({required String email, required String password}) {
    if (!isInitialised) throw NotInitializedException();
    if (email == "foo@mail.com") throw UserNotFoundAuthException();
    if (password == "foobar") throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false, email: 'foo@bar.com');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!isInitialised) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialised) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true, email: 'foo@bar.com');
    _user = newUser;
  }
  
}