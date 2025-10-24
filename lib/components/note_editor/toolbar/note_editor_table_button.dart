import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/note_editor/editor_extension.dart';
import 'package:notes/models/table_data.dart';
import 'package:notes/components/note_editor/embed_block/table/note_table_block_embed.dart';
import 'package:notes/providers/tables_provider.dart';

class NoteEditorTableButton extends ConsumerWidget {

  final QuillController controller;
  final double iconSize;
  const NoteEditorTableButton({super.key, required this.controller, required this.iconSize});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(icon: Icon(Icons.table_rows_outlined, size: iconSize), onPressed: () {
      final id = ref.read(tablesProvider.notifier).generatedId();
      ref.read(tablesProvider.notifier).insertTable(id, TableData());
      BlockEmbed table = BlockEmbed.custom(NoteTableBlockEmbed(id));
      controller.insertBlock(table);
    });
  }
}