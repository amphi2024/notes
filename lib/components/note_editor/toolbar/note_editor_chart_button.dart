import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';

class NoteEditorChartButton extends StatelessWidget {
  final NoteEditingController noteEditingController;
  const NoteEditorChartButton({super.key, required this.noteEditingController});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.question_mark),
      onPressed: () {

      },
    );
  }
}
