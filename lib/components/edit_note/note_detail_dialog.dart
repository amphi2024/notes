import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_export_button.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_import_button.dart';
import 'package:notes/extensions/date_extension.dart';
import 'package:notes/models/note.dart';

import '../../icons/icons.dart';

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
                  NoteEditorImportButton(controller: controller)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
void exportToNote(BuildContext context) async {
  // Note note = controller.note;
  // var bytes = utf8.encode(note.toFileContentBase64());
  // var selectedPath = await FilePicker.platform.saveFile(
  //     fileName: "${note.title}.note",
  //   bytes: bytes
  // );
  //
  // if(selectedPath != null) {
  //   var file = File(selectedPath);
  //   await file.writeAsBytes(bytes);
  //   showToast(context, AppLocalizations.of(context).get("@toast_message_note_export_success"));
  // }
}

void exportToHTML(BuildContext context) async {
  // Note note = controller.note;
  // var bytes = utf8.encode(note.toHTML(context));
  // var selectedPath = await FilePicker.platform.saveFile(
  //     fileName: "${note.title}.html",
  //     bytes: bytes
  // );
  // if(selectedPath != null) {
  //   var file = File(selectedPath);
  //   await file.writeAsBytes(bytes);
  //   showToast(context, AppLocalizations.of(context).get("@toast_message_note_export_success"));
  // }
}