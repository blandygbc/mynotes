import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group("Mock Authentication", () {
    final authProvider = MockAuthProvider();

    test("Should not be initialized to begin with", () {
      expect(authProvider.isInitialized, false);
    });

    test("Cannot log out if not initialized", () {
      expect(
        authProvider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test("Should be able to be initialized", () async {
      await authProvider.initialize();
      expect(authProvider.isInitialized, true);
    });

    test("User should be null after initialization", () {
      expect(authProvider.currentUser, null);
    });

    test("Should be able to initialized in less than 2 seconds", () async {
      await authProvider.initialize();
      expect(authProvider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test("Create user should delegate to logIn function", () async {
      final badEmailUser = authProvider.createUser(
        email: 'foo@bar.com',
        password: 'anypass',
      );
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final badPasswordUser = authProvider.createUser(
        email: 'abc@bar.com',
        password: 'foobar',
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));
      final user = await authProvider.createUser(
        email: 'foo',
        password: 'bar',
      );
      expect(authProvider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test("Logged in user should be able to get verified", () {
      authProvider.sendEmailVerification();
      final user = authProvider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test("Should be able to log aout and login again", () async {
      await authProvider.logOut();
      await authProvider.logIn(email: 'email', password: 'password');
      final user = authProvider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    const authUser = AuthUser(isEmailVerified: false);
    _user = authUser;
    return Future.value(authUser);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    _user = const AuthUser(isEmailVerified: true);
  }
}
