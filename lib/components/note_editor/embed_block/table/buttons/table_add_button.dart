import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/note_editor/embed_block/table/table/table_text_dialog.dart';
import 'package:notes/providers/editing_note_provider.dart';
import 'package:notes/utils/select_file_utils.dart';

import '../../../../../providers/tables_provider.dart';

class TableAddButton extends ConsumerWidget {
  final String tableId;
  final int rowIndex;
  final int colIndex;

  const TableAddButton({super.key, required this.tableId, required this.rowIndex, required this.colIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteId = ref.watch(editingNoteProvider).note.id;

    return PopupMenuButton(
        icon: const Icon(Icons.add_circle),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
                child: Text(AppLocalizations.of(context).get("@editor_table_insert_text")),
                onTap: () async {
                  String? result = await showDialog(
                      context: context,
                      builder: (context) {
                        return TableTextDialog(text: "");
                      });
                  if (result is String) {
                    Map<String, dynamic> map = {"text": result};
                    ref.read(tablesProvider.notifier).setValue(id: tableId, rowIndex: rowIndex, colIndex: colIndex, value: map);
                  }
                }),
            PopupMenuItem(
                child: Text(AppLocalizations.of(context).get("@editor_table_insert_image")),
                onTap: () async {
                  final files = await selectedImageFiles(noteId);
                  if(files.isNotEmpty) {
                    Map<String, dynamic> map = {"img": PathUtils.basename(files[0].path)};
                    ref.read(tablesProvider.notifier).setValue(id: tableId, rowIndex: rowIndex, colIndex: colIndex, value: map);
                  }
                }),
            PopupMenuItem(
                child: Text(AppLocalizations.of(context).get("@editor_table_insert_video")),
                onTap: () async {
                  final file = await selectedVideoFile(noteId);
                  if(file != null) {
                    Map<String, dynamic> map = {"video": PathUtils.basename(file.path)};
                    ref.read(tablesProvider.notifier).setValue(id: tableId, rowIndex: rowIndex, colIndex: colIndex, value: map);
                  }
                }),
            PopupMenuItem(
                child: Text(AppLocalizations.of(context).get("@editor_table_insert_date")),
                onTap: () async {
                  DateTime? result = await showDatePicker(context: context, firstDate: DateTime(1950), lastDate: DateTime.now());
                  if (result != null) {
                    var map = {"date": result.toUtc().millisecondsSinceEpoch};
                    ref.read(tablesProvider.notifier).setValue(id: tableId, rowIndex: rowIndex, colIndex: colIndex, value: map);
                  }
                })
          ];
        });
  }
}
