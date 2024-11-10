
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/divider/divider_block_embed.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';

class NoteEditorDividerButton extends StatelessWidget {

  final NoteEditingController noteEditingController;
  const NoteEditorDividerButton({super.key, required this.noteEditingController});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.horizontal_rule),
      onPressed: () {
        String dividerKey = noteEditingController.note.generatedTableKey();
        BlockEmbed divider = BlockEmbed.custom(DividerBlockEmbed(dividerKey));
        noteEditingController.insertBlock(divider);
      },
    );
  }
}
