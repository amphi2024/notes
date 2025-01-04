import 'dart:convert';
import 'dart:io';

import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/widgets/menu/popup/show_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/extensions/note_extension.dart';
import 'package:notes/models/icons.dart';
import 'package:notes/models/note.dart';
import 'package:notes/utils/toast.dart';

class NoteEditorExportButton extends StatelessWidget {
  final NoteEditingController noteEditingController;
  const NoteEditorExportButton({super.key, required this.noteEditingController});

  void exportToNote(BuildContext context) async {
    Note note = noteEditingController.note;
    var bytes = utf8.encode(note.toFileContentBase64());
    var selectedPath = await FilePicker.platform.saveFile(
        fileName: "${note.title}.note",
      bytes: bytes
    );

    if(selectedPath != null) {
      var file = File(selectedPath);
      await file.writeAsBytes(bytes);
      showToast(context, "");
    }
  }

  void exportToHTML(BuildContext context) async {
    Note note = noteEditingController.note;
    var bytes = utf8.encode(note.toHTML(context));
    var selectedPath = await FilePicker.platform.saveFile(
        fileName: "${note.title}.html",
        bytes: bytes
    );
    if(selectedPath != null) {
      var file = File(selectedPath);
      await file.writeAsBytes(bytes);
      showToast(context, "");
    }
  }

  // void exportAsMarkdown(BuildContext context) async {

  // }

  // void exportAsWord(BuildContext context) async {

  // }

  // void exportAsPDF() async {
  //   Note note = noteEditingController.note;

  // }
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    return IconButton(
        icon: Icon(AppIcons.export, size: 20),
        onPressed: () {
          showMenuByRelative(context: context, items: [
            PopupMenuItem(child: Text(localizations.get("@note_export_label_note")), onTap: () => exportToNote(context)),
            PopupMenuItem(child: Text(localizations.get("@note_export_label_html")), onTap: () => exportToHTML(context)),
            // PopupMenuItem(child: Text(localizations.get("@note_export_label_markdown")), onTap: () => exportAsMarkdown(context)),
            //PopupMenuItem(child: Text(localizations.get("@note_export_label_word")), onTap: exportAsWord),
            // PopupMenuItem(child: Text(localizations.get("@note_export_label_pdf")), onTap: exportAsPDF),
          ]);
        });
  }
}
