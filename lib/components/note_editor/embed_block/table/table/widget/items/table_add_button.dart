import 'dart:io';

import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/embed_block/table/table/widget/dialogs/table_text_dialog.dart';
import 'package:notes/models/app_state.dart';

class TableAddButton extends StatelessWidget {
  final void Function(Map<String, dynamic>) onEdit;
  final void Function() addColumnAfter;
  final void Function() addColumnBefore;
  final void Function() addRowBefore;
  final void Function() addRowAfter;
  final void Function() removeColumn;
  final void Function() removeRow;
  const TableAddButton(
      {super.key,
      required this.onEdit,
      required this.addColumnAfter,
      required this.addColumnBefore,
      required this.addRowBefore,
      required this.addRowAfter,
      required this.removeColumn,
      required this.removeRow});

  @override
  Widget build(BuildContext context) {
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
                  if (result != null) {
                    Map<String, dynamic> map = {"text": result};
                    onEdit(map);
                  }
                }),
            PopupMenuItem(
                child: Text(AppLocalizations.of(context).get("@editor_table_insert_image")),
                onTap: () async {
                  var files = await appState.noteEditingController.selectedImageFiles();
                  for(var file in files) {
                    onEdit({"img": PathUtils.basename(file.path)});
                  }
                }),
            PopupMenuItem(
                child: Text(AppLocalizations.of(context).get("@editor_table_insert_video")),
                onTap: () async {
                  File? file = await appState.noteEditingController.selectedVideoFile();
                  if (file != null) {
                    onEdit({"video": PathUtils.basename(file.path)});
                  }
                }),
            PopupMenuItem(
                child: Text(AppLocalizations.of(context).get("@editor_table_insert_date")),
                onTap: () async {
                  DateTime? result = await showDatePicker(context: context, firstDate: DateTime(1950), lastDate: DateTime.now());
                  if (result != null) {
                    onEdit({"date": result.toUtc().millisecondsSinceEpoch});
                  }
                })
          ];
        });
  }
}
