import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/note_editor/editor_extension.dart';
import 'package:notes/components/note_editor/embed_block/divider/divider_block_embed.dart';

class NoteEditorDividerButton extends ConsumerWidget {

  final QuillController controller;
  final double iconSize;

  const NoteEditorDividerButton({super.key, required this.controller, required this.iconSize});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(Icons.horizontal_rule, size: iconSize),
      onPressed: () {
        final block = BlockEmbed.custom(DividerBlockEmbed(""));
        controller.insertBlock(block);
      },
    );
  }
}
