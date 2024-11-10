import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/edit_style/edit_note_detail.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';

class EditDetailDialog extends StatefulWidget {

  final NoteEditingController noteEditingController;
  final void Function(void Function()) onChange;
  const EditDetailDialog({super.key, required this.noteEditingController, required this.onChange});

  @override
  State<EditDetailDialog> createState() => _EditDetailDialogState();
}

class _EditDetailDialogState extends State<EditDetailDialog> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: EditNoteDetail(noteEditingController: widget.noteEditingController, onChange: widget.onChange,),
    );
  }
}
