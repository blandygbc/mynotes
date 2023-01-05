import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/utils/dialogs/logout_dialog.dart';
import 'package:mynotes/view/notes/create_update_note_view.dart';
import 'package:mynotes/view/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  static String routeName = '/NotesView';

  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  // late final NotesService _notesService;
  // String get userEmail => AuthService.firebase().currentUser!.email;
  late final FirebaseCloudSotrage _cloudStorageService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    // _notesService = NotesService();
    _cloudStorageService = FirebaseCloudSotrage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NavigatorState navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            onPressed: () {
              navigator.pushNamed(CreateUpdateNoteView.routeName);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                }
            }
          }, itemBuilder: (iBContext) {
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Logout'),
              )
            ];
          })
        ],
      ),
      body: StreamBuilder(
          // stream: _notesService.allNotes,
          stream: _cloudStorageService.allNotes(ownerUserId: userId),
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  // final allNotes = snapshot.data as List<DatabaseNote>;
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return NotesListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      // await _notesService.deleteNote(id: note.id);
                      await _cloudStorageService.deleteNote(
                          documentId: note.documentId);
                    },
                    onTap: (note) => navigator.pushNamed(
                      CreateUpdateNoteView.routeName,
                      arguments: note,
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          })),
      // body: FutureBuilder(
      //   future: _notesService.getOrCreateUser(email: userEmail),
      //   builder: ((context, snapshot) {
      //     switch (snapshot.connectionState) {
      //       case ConnectionState.done:
      //         return StreamBuilder(
      //             stream: _notesService.allNotes,
      //             builder: ((context, snapshot) {
      //               switch (snapshot.connectionState) {
      //                 case ConnectionState.waiting:
      //                 case ConnectionState.active:
      //                   if (snapshot.hasData) {
      //                     final allNotes = snapshot.data as List<DatabaseNote>;
      //                     return NotesListView(
      //                       notes: allNotes,
      //                       onDeleteNote: (DatabaseNote note) async {
      //                         await _notesService.deleteNote(id: note.id);
      //                       },
      //                       onTap: (DatabaseNote note) =>
      //                           Navigator.of(context).pushNamed(
      //                         CreateUpdateNoteView.routeName,
      //                         arguments: note,
      //                       ),
      //                     );
      //                   } else {
      //                     return const CircularProgressIndicator();
      //                   }
      //                 default:
      //                   return const CircularProgressIndicator();
      //               }
      //             }));
      //       default:
      //         return const CircularProgressIndicator();
      //     }
      //   }),
      // ),
    );
  }
}
