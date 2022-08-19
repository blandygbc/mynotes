import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/config/routes.dart';
import 'package:mynotes/view/login_view.dart';

class VerifyEmailView extends StatefulWidget {
  static String routeName = '/register';

  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify your email'),
      ),
      body: Column(children: [
        const SizedBox(
          height: 10,
        ),
        const Text('Please verify your email address:'),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          },
          child: const Text('Send email verification'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: routes[LoginView.routeName]!),
              (route) => false,
            );
          },
          child: const Text('Go back to login'),
        ),
      ]),
    );
  }
}
