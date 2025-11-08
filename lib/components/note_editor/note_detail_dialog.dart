import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_export_button.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_import_button.dart';
import 'package:notes/utils/date_utils.dart';
import 'package:notes/models/note.dart';

class NoteDetailDialog extends StatelessWidget {
  final Note note;
  final QuillController controller;
  const NoteDetailDialog({super.key, required this.note, required this.controller});

  @override
  Widget build(BuildContext context) {
    int length = 0;
    for (var content in note.content) {
      if (content["type"] == "text") {
        String value = content["value"];
        length += value.length;
      }
    }
    return Dialog(
      child: Container(
        width: 350,
        height: 150,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              SelectableText(
                  "${AppLocalizations.of(context).get("@created_date")}: ${note.created.toLocalizedString(context)} \n${AppLocalizations.of(context).get("@modified_date")}: ${note.modified.toLocalizedString(context)}\n${AppLocalizations.of(context).get("@length")}: $length"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NoteEditorExportButton(note: note, iconSize: 20),
                  NoteEditorImportButton(note: note, controller: controller)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}