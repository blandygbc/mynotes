import 'package:flutter/cupertino.dart';
import 'package:mynotes/view/login_view.dart';
import 'package:mynotes/view/notes_view.dart';
import 'package:mynotes/view/register_view.dart';
import 'package:mynotes/view/verify_email_view.dart';

final Map<String, WidgetBuilder> routes = {
  LoginView.routeName: (context) => const LoginView(),
  RegisterView.routeName: (context) => const RegisterView(),
  VerifyEmailView.routeName: (context) => const VerifyEmailView(),
  NotesView.routeName: (context) => const NotesView(),
};
