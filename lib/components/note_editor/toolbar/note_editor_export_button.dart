import 'dart:convert';
import 'dart:io';

import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/widgets/menu/popup/show_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/utils/note_converter.dart';
import 'package:notes/icons/icons.dart';
import 'package:notes/models/note.dart';
import 'package:notes/utils/toast.dart';

class NoteEditorExportButton extends StatelessWidget {
  final Note note;
  final double iconSize;
  const NoteEditorExportButton({super.key, required this.note, required this.iconSize});

  void exportToNote(BuildContext context) async {
    var bytes = utf8.encode(note.toBundledFileContent());
    var selectedPath = await FilePicker.platform.saveFile(
        fileName: "${note.title}.note",
      bytes: bytes
    );

    if(selectedPath != null) {
      var file = File(selectedPath);
      await file.writeAsBytes(bytes);
      showToast(context, AppLocalizations.of(context).get("@toast_message_note_export_success"));
    }
  }

  void exportToHTML(BuildContext context) async {
    final selectedPath = await FilePicker.platform.saveFile(
        fileName: "${note.title}.html"
    );
    if(selectedPath != null) {
      final file = File(selectedPath);
      await file.writeAsString(note.toHTML(context));
      showToast(context, AppLocalizations.of(context).get("@toast_message_note_export_success"));
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
    return PopupMenuButton(
        icon: Icon(AppIcons.export, size: 20),
        itemBuilder: (context) {
          return [
            PopupMenuItem(child: Text(AppLocalizations.of(context).get("@note_export_label_note")), onTap: () => exportToNote(context)),
            PopupMenuItem(child: Text(AppLocalizations.of(context).get("@note_export_label_html")), onTap: () => exportToHTML(context)),
          ];
        });
  }
}
