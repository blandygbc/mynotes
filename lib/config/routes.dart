import 'package:flutter/cupertino.dart';
import 'package:mynotes/view/auth/login_view.dart';
import 'package:mynotes/view/notes/create_update_note_view.dart';
import 'package:mynotes/view/notes/notes_view.dart';
import 'package:mynotes/view/auth/register_view.dart';
import 'package:mynotes/view/auth/verify_email_view.dart';

final Map<String, WidgetBuilder> routes = {
  // LoginView.routeName: (context) => const LoginView(),
  // RegisterView.routeName: (context) => const RegisterView(),
  // VerifyEmailView.routeName: (context) => const VerifyEmailView(),
  // NotesView.routeName: (context) => const NotesView(),
  CreateUpdateNoteView.routeName: (context) => const CreateUpdateNoteView(),
};
