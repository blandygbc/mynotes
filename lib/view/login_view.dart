import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/config/routes.dart';
import 'package:mynotes/constants/app_constants.dart';
import 'package:mynotes/utils/exceptions_handlers/show_error_dialog.dart';
import 'package:mynotes/view/notes_view.dart';
import 'package:mynotes/view/register_view.dart';
import 'package:mynotes/view/verify_email_view.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  static String routeName = "/login";
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    NavigatorState navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user = FirebaseAuth.instance.currentUser;
                if (user!.emailVerified) {
                  navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: routes[NotesView.routeName]!),
                    (route) => false,
                  );
                } else {
                  navigator.pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: routes[VerifyEmailView.routeName]!),
                    (route) => false,
                  );
                }
              } on FirebaseAuthException catch (e) {
                devtools.log('Failed with error code: ${e.code}');
                devtools.log(e.message.toString());
                if (e.code == fireErrCodeUserNotFound) {
                  await showErrorDialog(
                    context,
                    'User not found.\n${e.message}',
                  );
                } else if (e.code == fireErrCodeWrongPass) {
                  await showErrorDialog(
                    context,
                    'Wrong credentials.\n${e.message}',
                  );
                } else {
                  await showErrorDialog(
                    context,
                    'Failed with error code: ${e.code}',
                  );
                }
              } catch (e) {
                await showErrorDialog(
                  context,
                  e.toString(),
                );
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: routes[RegisterView.routeName]!),
                (route) => false,
              );
            },
            child: const Text('Not registered yet? Register here!'),
          )
        ],
      ),
    );
  }
}
