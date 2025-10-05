import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NoteEditorAudioButton extends StatelessWidget {

  final QuillController noteEditingController;
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
