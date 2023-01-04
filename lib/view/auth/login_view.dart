import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:mynotes/config/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/utils/dialogs/error_dialog.dart';
import 'package:mynotes/view/notes/notes_view.dart';
import 'package:mynotes/view/auth/register_view.dart';
import 'package:mynotes/view/auth/verify_email_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            child: const Text('Login'),
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                context.read<AuthBloc>().add(
                      AuthEventLogIn(
                        email,
                        password,
                      ),
                    );
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  'User not found.',
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Wrong credentials.',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Authentication error',
                );
              } catch (e) {
                devtools.log(e.toString());
                await showErrorDialog(
                  context,
                  e.toString(),
                );
              }
            },
          ),
          TextButton(
            child: const Text('Not registered yet? Register here!'),
            onPressed: () {
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: routes[RegisterView.routeName]!),
                (route) => false,
              );
            },
          )
        ],
      ),
    );
  }
}
