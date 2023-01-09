import 'package:flutter/material.dart';
import 'package:mynotes/extensions/build_context/get_arguments.dart';
import 'package:mynotes/l10n/generated/l10n.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/utils/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  static const routeName = "/notes/note";
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  //DatabaseNote? _note;
  //late final NotesService _notesService;
  CloudNote? _cloudNote;
  late final FirebaseCloudSotrage _cloudStorageService;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    //_notesService = NotesService();
    _cloudStorageService = FirebaseCloudSotrage();
    _textEditingController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _cloudNote;
    if (note == null) return;
    final text = _textEditingController.text;
    // await _notesService.updateNote(
    //   note: note,
    //   text: text,
    // );
    await _cloudStorageService.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textEditingController.removeListener(_textControllerListener);
    _textEditingController.addListener(_textControllerListener);
  }

  Future<CloudNote> createOrGetNote(BuildContext context) async {
    //final widgetNote = context.getArgument<DatabaseNote>();
    final widgetNote = context.getArgument<CloudNote>();
    if (widgetNote != null) {
      _cloudNote = widgetNote;
      _textEditingController.text = widgetNote.text;
      return widgetNote;
    }

    // final existingNote = _cloudNote;
    // if (existingNote != null) return existingNote;

    // final owner = await _notesService.getUser(
    //   email: AuthService.firebase().currentUser!.email,
    // );
    // final newNote = await _notesService.createNote(owner: owner);
    final userId = AuthService.firebase().currentUser!.id;
    final newNote = await _cloudStorageService.createNote(ownerUserId: userId);
    _cloudNote = newNote;
    return newNote;
  }

  void _deleteEmptyNote() {
    final note = _cloudNote;
    if (_textEditingController.text.isEmpty && note != null) {
      // _notesService.deleteNote(id: note.id);
      _cloudStorageService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfNotEmpty() async {
    final note = _cloudNote;
    final text = _textEditingController.text;
    if (note != null && text.isNotEmpty) {
      // await _notesService.updateNote(
      //   note: note,
      //   text: text,
      // );
      await _cloudStorageService.updateNote(
        documentId: note.documentId,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteEmptyNote();
    _saveNoteIfNotEmpty();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).note),
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textEditingController.text;
              if (_cloudNote == null || text.isEmpty) {
                await showCannotShareEmptyNoteDialog(context);
              } else {
                Share.share(text);
              }
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: FutureBuilder(
        future: createOrGetNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: L10n.of(context).start_typing_your_note,
                ),
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
