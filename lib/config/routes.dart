import 'package:flutter/cupertino.dart';
import 'package:mynotes/view/login_view.dart';
import 'package:mynotes/view/register_view.dart';

final Map<String, WidgetBuilder> routes = {
  LoginView.routeName: (context) => const LoginView(),
  RegisterView.routeName: (context) => const RegisterView(),
};
