import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/edit_style/edit_note_detail.dart';
import 'package:flutter_quill/flutter_quill.dart';

class EditDetailDialog extends StatefulWidget {

  final QuillController noteEditingController;
  const EditDetailDialog({super.key, required this.noteEditingController});

  @override
  State<EditDetailDialog> createState() => _EditDetailDialogState();
}

class _EditDetailDialogState extends State<EditDetailDialog> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: EditNoteDetail(controller: widget.noteEditingController),
    );
  }
}
