import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/editor_extension.dart';
import 'package:notes/components/note_editor/embed_block/divider/divider_block_embed.dart';
import 'package:notes/models/note_embed_blocks.dart';

class NoteEditorDividerButton extends StatelessWidget {

  final QuillController controller;
  final double iconSize;
  const NoteEditorDividerButton({super.key, required this.controller, required this.iconSize});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.horizontal_rule, size: iconSize),
      onPressed: () {
        String dividerKey = noteEmbedBlocks.generatedTableKey();
        BlockEmbed divider = BlockEmbed.custom(DividerBlockEmbed(dividerKey));
        controller.insertBlock(divider);
      },
    );
  }
}
