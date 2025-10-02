import 'package:flutter/material.dart';
import 'package:notes/components/edit_note/note_detail_dialog.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';

class NoteEditorDetailButton extends StatelessWidget {

  final NoteEditingController noteEditingController;
  const NoteEditorDetailButton({super.key, required this.noteEditingController});

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(Icons.more_vert_rounded, size: 20), onPressed: () {
      // showDialog(context: context, builder: (context) {
      //   return NoteDetailDialog(note: appState.noteEditingController.note);
      // });
    });
  }
}
