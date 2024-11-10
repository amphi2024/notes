import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';

class NoteEditorAudioButton extends StatelessWidget {

  final NoteEditingController noteEditingController;
  const NoteEditorAudioButton({super.key, required this.noteEditingController});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.audiotrack),
      onPressed: () {

      },
    );
  }
}
