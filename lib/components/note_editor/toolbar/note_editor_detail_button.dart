import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/edit_note/note_detail_dialog.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/providers/editing_note_provider.dart';

class NoteEditorDetailButton extends ConsumerWidget {

  final QuillController controller;
  const NoteEditorDetailButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
        icon: Icon(Icons.more_vert_rounded, size: 20), onPressed: () {
      showDialog(context: context, builder: (context) {
        return NoteDetailDialog(note: ref.watch(editingNoteProvider).note);
      });
    });
  }
}
