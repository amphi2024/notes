import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';

class NoteEditorRedoButton extends StatefulWidget {

  final NoteEditingController noteEditingController;
  const NoteEditorRedoButton({super.key, required this.noteEditingController});

  @override
  State<NoteEditorRedoButton> createState() => _NoteEditorRedoButtonState();
}

class _NoteEditorRedoButtonState extends State<NoteEditorRedoButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.redo,
          color: widget.noteEditingController.hasRedo
              ? Theme.of(context).iconTheme.color
              : Theme.of(context).disabledColor,
          size: 20,
        ),
      onPressed: () {
        setState(() {
          widget.noteEditingController.redo();
        });
      }
    );
  }
}
