import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';

import '../note_editor/note_editor.dart';

class EditNoteToolbar extends StatefulWidget {
  final NoteEditingController noteEditingController;
  final void Function(void Function()) onNoteStyleChange;
  const EditNoteToolbar({super.key, required this.noteEditingController, required this.onNoteStyleChange});

  @override
  State<EditNoteToolbar> createState() => _EditNoteToolbarState();
}

class _EditNoteToolbarState extends State<EditNoteToolbar> {
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    var buttons = noteEditorToolbarButtons(widget.noteEditingController, widget.onNoteStyleChange);
    return Container(
      height: 60,
      color: widget.noteEditingController.note.backgroundColorByTheme(Theme.of(context).brightness == Brightness.dark) ?? Theme.of(context).appBarTheme.backgroundColor,
      child: PageView(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buttons[0],
              buttons[1],
              buttons[2],
              buttons[3],
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buttons[4],
              buttons[5],
              buttons[6],
              buttons[7],
            ],
          ),
        ],
      ),
    );
  }
}
