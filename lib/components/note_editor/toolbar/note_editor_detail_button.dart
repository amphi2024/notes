import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/edit_note/note_detail_dialog.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/providers/editing_note_provider.dart';

class NoteEditorDetailButton extends ConsumerWidget {

  final QuillController controller;
  final double iconSize;
  const NoteEditorDetailButton({super.key, required this.controller, required this.iconSize});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
        icon: Icon(Icons.info_outline, size: iconSize), onPressed: () {
      showDialog(context: context, builder: (context) {
        return NoteDetailDialog(note: ref.watch(editingNoteProvider).note, controller: controller);
      });
    });
  }
}
