import 'dart:io';

import 'package:amphi/models/app.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/utils/file_name_utils.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:amphi/widgets/menu/popup/show_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/extensions/note_extension.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/content.dart';
import 'package:notes/models/icons.dart';
import 'package:notes/models/note.dart';

class NoteEditorExportButton extends StatelessWidget {
  final NoteEditingController noteEditingController;
  const NoteEditorExportButton({super.key, required this.noteEditingController});

  void exportToNote() async {
    Note note = noteEditingController.note;
    String? selectedPath = await FilePicker.platform.saveFile(fileName: "${note.title}.note");

    if (selectedPath != null) {
      if (App.isDesktop()) {
        Directory directory = Directory(selectedPath.split(".").first); //  ...Downloads/my_note.note  ->   ...Downloads/my_note
        File file = File(selectedPath);
        await file.writeAsString(note.toFileContent());

        await directory.create();

        String noteFileNameOnly = FilenameUtils.nameOnly(note.filename);
        for (Content content in note.contents) {
          switch (content.type) {
            case "img":
              File file = File(PathUtils.join(appStorage.notesPath, noteFileNameOnly, "images", content.value));
              file.copy(PathUtils.join(directory.path, content.value));
              break;

            case "video":
              File file = File(PathUtils.join(appStorage.notesPath, noteFileNameOnly, "videos", content.value));
              file.copy(PathUtils.join(directory.path, content.value));
              break;
          }
        }
      }
    }
  }

  void exportToHTMl() async {
    Note note = noteEditingController.note;
    String? selectedPath = await FilePicker.platform.saveFile(fileName: "${note.title}.html");

    if (selectedPath != null) {
      if (App.isDesktop()) {
        Directory directory = Directory(selectedPath.split(".").first);
        String html = note.toHTML(PathUtils.basenameWithoutExtension(directory.path));
        File file = File(selectedPath);
        await file.writeAsString(html);

        await directory.create();

        String noteFileNameOnly = FilenameUtils.nameOnly(note.filename);
        for (Content content in note.contents) {
          switch (content.type) {
            case "img":
              File file = File(PathUtils.join(appStorage.notesPath, noteFileNameOnly, "images", content.value));
              file.copy(PathUtils.join(directory.path, content.value));
              break;

            case "video":
              File file = File(PathUtils.join(appStorage.notesPath, noteFileNameOnly, "videos", content.value));
              file.copy(PathUtils.join(directory.path, content.value));
              break;
          }
        }
      }
    }
  }

  void exportAsMarkdown() async {}

  void exportAsWord() async {}

  void exportAsPDF() async {}
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    return IconButton(
        icon: Icon(AppIcons.export, size: 20),
        onPressed: () {
          showMenuByRelative(context: context, items: [
            PopupMenuItem(child: Text(localizations.get("@note_export_label_note")), onTap: exportToNote),
            PopupMenuItem(child: Text(localizations.get("@note_export_label_html")), onTap: exportToHTMl),
            PopupMenuItem(child: Text(localizations.get("@note_export_label_markdown")), onTap: exportAsMarkdown),
            PopupMenuItem(child: Text(localizations.get("@note_export_label_word")), onTap: exportAsWord),
            PopupMenuItem(child: Text(localizations.get("@note_export_label_pdf")), onTap: exportAsPDF),
          ]);
        });
  }
}
