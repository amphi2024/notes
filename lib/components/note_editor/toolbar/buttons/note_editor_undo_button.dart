import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';

class NoteEditorUndoButton extends StatefulWidget {

  final NoteEditingController noteEditingController;
  const NoteEditorUndoButton({super.key, required this.noteEditingController});

  @override
  State<NoteEditorUndoButton> createState() => _NoteEditorUndoButtonState();
}

class _NoteEditorUndoButtonState extends State<NoteEditorUndoButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(
      Icons.undo,
      color: widget.noteEditingController.hasUndo
          ? Theme.of(context).iconTheme.color
          : Theme.of(context).disabledColor,
      size: 20,
    ) , onPressed: () {
      setState(() {
        widget.noteEditingController.undo();
      });
    });
  }
}
