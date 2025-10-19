import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../providers/editing_note_provider.dart';
import '../buttons/table_edit_button.dart';
import '../../image/image_block.dart';

class TableImage extends ConsumerWidget {
  final String filename;
  final int rowIndex;
  final int colIndex;
  final String tableId;
  final bool readOnly;

  const TableImage(
      {super.key, required this.readOnly, required this.filename, required this.rowIndex, required this.colIndex, required this.tableId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteId = ref.read(editingNoteProvider).note.id;

    if (readOnly) {
      return Padding(
          padding: EdgeInsets.all(7.5),
          child: ImageBlock(
            noteId: noteId,
            filename: filename
          ));
    }

    return Padding(
      padding: const EdgeInsets.all(7.5),
      child: Column(
        children: [
          TableEditButton(tableId: tableId, rowIndex: rowIndex, colIndex: colIndex),
          ImageBlock(
              noteId: noteId,
              filename: filename
          )
        ],
      ),
    );
  }
}
