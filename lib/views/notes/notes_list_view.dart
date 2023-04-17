// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:mynotesfinal/services/crud/notes_service.dart';

import '../../utilites/dialog/delete_dialog.dart';

typedef NotesCallBack = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final NotesCallBack onDeleteNote;
  final NotesCallBack onTap;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int index) {
          final note = notes[index];
          return ListTile(
            onTap: () {
              onTap(note);
            },
            title: Text(
              note.text,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  onDeleteNote(note);
                }
              },
              icon: Icon(Icons.delete_outlined),
            ),
          );
        });
  }
}
