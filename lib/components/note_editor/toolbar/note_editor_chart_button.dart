import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NoteEditorChartButton extends StatelessWidget {
  final QuillController noteEditingController;
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
