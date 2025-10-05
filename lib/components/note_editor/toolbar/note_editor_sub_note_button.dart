import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/note_editor/editor_extension.dart';
import 'package:notes/components/note_editor/embed_block/sub_note/sub_note_block_embed.dart';
import 'package:notes/models/note_embed_blocks.dart';

class NoteEditorSubNoteButton extends ConsumerWidget {

  final QuillController controller;

  const NoteEditorSubNoteButton(
      {super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(Icons.note_add),
      onPressed: () {
        String subNoteKey = noteEmbedBlocks.generatedSubNoteKey();
        BlockEmbed blockEmbed = BlockEmbed.custom(
            SubNoteBlockEmbed(subNoteKey)
        );
        controller.insertBlock(blockEmbed);
      },
    );
  }
}
