import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/table/table/table_data.dart';
import 'package:notes/components/note_editor/embed_block/table/note_data_block_embed.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';

class NoteEditorTableButton extends StatelessWidget {

  final NoteEditingController noteEditingController;
  const NoteEditorTableButton({super.key, required this.noteEditingController});

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(Icons.table_rows_outlined), onPressed: () {
      String tableKey = noteEditingController.note.generatedTableKey();
      noteEditingController.note.tables[tableKey] = TableData();
      BlockEmbed table = BlockEmbed.custom(NoteDataBlockEmbed(tableKey));
      noteEditingController.insertBlock(table);
    });
  }
}