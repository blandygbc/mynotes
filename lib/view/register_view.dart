import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/config/routes.dart';
import 'package:mynotes/constants/app_constants.dart';
import 'package:mynotes/utils/exceptions_handlers/show_error_dialog.dart';
import 'package:mynotes/view/login_view.dart';
import 'package:mynotes/view/verify_email_view.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  static String routeName = "/register";
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
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
            child: const Text('Register'),
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                navigator.pushNamed(VerifyEmailView.routeName);
              } on FirebaseAuthException catch (e) {
                devtools.log('Failed with error code: ${e.code}');
                devtools.log(e.message.toString());
                if (e.code == fireErrCodeWeakPass) {
                  await showErrorDialog(
                    context,
                    'Weak Password.\n${e.message}',
                  );
                } else if (e.code == fireErrCodeEmailInUse) {
                  await showErrorDialog(
                    context,
                    'Email already in use.\n${e.message}',
                  );
                } else if (e.code == fireErrCodeInvalidEmail) {
                  await showErrorDialog(
                    context,
                    'Email is invalid.\n${e.message}',
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
          ),
          TextButton(
            child: const Text('Already registered? Login here!'),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: routes[LoginView.routeName]!),
                (route) => false,
              );
            },
          )
        ],
      ),
    );
  }
}
