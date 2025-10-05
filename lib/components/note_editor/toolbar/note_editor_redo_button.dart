import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NoteEditorRedoButton extends StatefulWidget {

  final QuillController controller;
  const NoteEditorRedoButton({super.key, required this.controller});

  @override
  State<NoteEditorRedoButton> createState() => _NoteEditorRedoButtonState();
}

class _NoteEditorRedoButtonState extends State<NoteEditorRedoButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.redo,
          color: widget.controller.hasRedo
              ? Theme.of(context).iconTheme.color
              : Theme.of(context).disabledColor,
          size: 20,
        ),
      onPressed: () {
        setState(() {
          widget.controller.redo();
        });
      }
    );
  }
}
