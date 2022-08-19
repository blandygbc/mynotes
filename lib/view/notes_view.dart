import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/config/routes.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/view/login_view.dart';

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  static String routeName = '/NotesView';

  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    NavigatorState navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          PopupMenuButton(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                devtools.log(shouldLogout.toString());
                if (shouldLogout) {
                  await FirebaseAuth.instance.signOut();
                  navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: routes[LoginView.routeName]!),
                    (_) => false,
                  );
                }
                break;
            }
          }, itemBuilder: (iBContext) {
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Sign Out'),
              )
            ];
          })
        ],
      ),
      body: Column(),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (dialogContex) {
        return AlertDialog(
            title: const Text('Sing out'),
            content: const Text('Are you shure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Sing out'),
              ),
            ]);
      }).then((value) => value ?? false);
}
