import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NoteEditorUndoButton extends StatefulWidget {

  final QuillController controller;
  const NoteEditorUndoButton({super.key, required this.controller});

  @override
  State<NoteEditorUndoButton> createState() => _NoteEditorUndoButtonState();
}

class _NoteEditorUndoButtonState extends State<NoteEditorUndoButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(
      Icons.undo,
      color: widget.controller.hasUndo
          ? Theme.of(context).iconTheme.color
          : Theme.of(context).disabledColor,
      size: 20,
    ) , onPressed: () {
      setState(() {
        widget.controller.undo();
      });
    });
  }
}
