import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/editor_extension.dart';
import 'package:notes/components/note_editor/embed_block/table/table/table_data.dart';
import 'package:notes/components/note_editor/embed_block/table/note_table_block_embed.dart';
import 'package:notes/models/note_embed_blocks.dart';

class NoteEditorTableButton extends StatelessWidget {

  final QuillController controller;
  const NoteEditorTableButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(Icons.table_rows_outlined), onPressed: () {
      String tableKey = noteEmbedBlocks.generatedTableKey();
      noteEmbedBlocks.tables[tableKey] = TableData();
      BlockEmbed table = BlockEmbed.custom(NoteTableBlockEmbed(tableKey));
      controller.insertBlock(table);
    });
  }
}