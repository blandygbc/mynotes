import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/services/auth/firebase_errorcodes_constants.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLogeedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == fireErrCodeWeakPass) {
        throw WeakPasswordAuthException();
      } else if (e.code == fireErrCodeEmailInUse) {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == fireErrCodeInvalidEmail) {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        log('Login auth provider: UserNotLogeedInAuthException');
        throw UserNotLogeedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == fireErrCodeUserNotFound) {
        throw UserNotFoundAuthException();
      } else if (e.code == fireErrCodeWrongPass) {
        throw WrongPasswordAuthException();
      } else if (e.code == fireErrCodeInvalidEmail) {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      log('Logout auth provider: UserNotLogeedInAuthException');
      throw UserNotLogeedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      log('Send email auth provider: UserNotLogeedInAuthException');
      throw UserNotLogeedInAuthException();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case fireAuthErrCodeInvalidEmail:
          throw InvalidEmailAuthException();
        case fireAuthErrCodeUserNotFound:
          throw UserNotFoundAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
}
