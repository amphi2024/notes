import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';

class NoteEditorMindMapButton extends StatelessWidget {

  final NoteEditingController noteEditingController;
  const NoteEditorMindMapButton({super.key, required this.noteEditingController});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.map),
      onPressed: () {

      },
    );
  }
}
