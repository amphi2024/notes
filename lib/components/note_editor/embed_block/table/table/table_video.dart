import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/note_editor/embed_block/table/buttons/table_edit_button.dart';

import '../../../../../providers/editing_note_provider.dart';
import '../../video/video_block.dart';

class TableVideo extends ConsumerWidget {
  final String filename;
  final int rowIndex;
  final int colIndex;
  final String tableId;
  final bool readOnly;
  const TableVideo({super.key, required this.filename, required this.rowIndex, required this.colIndex, required this.tableId, required this.readOnly});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteId = ref.read(editingNoteProvider).note.id;
    if (readOnly) {
      return Padding(padding: EdgeInsets.all(7.5), child: VideoBlock(filename: filename, noteId: noteId));
    }

    return Padding(
      padding: const EdgeInsets.all(7.5),
      child: Column(
        children: [
          TableEditButton(colIndex: colIndex, rowIndex: rowIndex, tableId: tableId),
          VideoBlock(filename: filename, noteId: noteId),
        ],
      ),
    );
  }
}