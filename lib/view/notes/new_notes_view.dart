import 'package:flutter/material.dart';

class NewNotesView extends StatefulWidget {
  static const routeName = "/notes/new-note";
  const NewNotesView({super.key});

  @override
  State<NewNotesView> createState() => _NewNotesViewState();
}

class _NewNotesViewState extends State<NewNotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: const Text('Building a new note form..'),
    );
  }
}
