import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/components/note_editor/note_editor.dart';

class ViewPagerPage extends StatefulWidget {
  final NoteEditingController noteEditingController;
  final bool readOnly;
  const ViewPagerPage({super.key, required this.noteEditingController, required this.readOnly});

  @override
  State<ViewPagerPage> createState() => _ViewPagerPageState();
}

class _ViewPagerPageState extends State<ViewPagerPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.readOnly) {
      return NoteEditor(noteEditingController: widget.noteEditingController);
    } else {
      return MouseRegion(
        cursor: SystemMouseCursors.basic,
        child: NoteEditor(noteEditingController: widget.noteEditingController),
      );
    }
  }
}
