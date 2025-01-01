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
    String? selectedPath = await FilePicker.platform.saveFile(fileName: "${note.title}.note");

    if (selectedPath != null) {

        File file = File(selectedPath);
        await file.writeAsString(note.toFileContentBase64());

        showToast(context, "");

    }
  }

  void exportToHTML(BuildContext context) async {
    Note note = noteEditingController.note;
    String? selectedPath = await FilePicker.platform.saveFile(fileName: "${note.title}.html");

    if (selectedPath != null) {
        Directory directory = Directory(selectedPath.split(".").first);
        String html = note.toHTML(context);
        File file = File(selectedPath);
        await file.writeAsString(html);

        await directory.create();

        showToast(context, "");
    }
  }

  // void exportAsMarkdown(BuildContext context) async {
  //   Note note = noteEditingController.note;
  //   String? selectedPath = await FilePicker.platform.saveFile(fileName: "${note.title}.md");
  //
  //   if (selectedPath != null) {
  //     File file = File(selectedPath);
  //     await file.writeAsString(note.toMarkdown());
  //     showToast(context, "");
  //   }
  // }

  // void exportAsWord(BuildContext context) async {
  //   Note note = noteEditingController.note;
  //   String? selectedPath = await FilePicker.platform.saveFile(fileName: "${note.title}.html");
  //
  //   if (selectedPath != null) {
  //     showToast(context, "");
  //   }
  // }

  // void exportAsPDF() async {
  //   Note note = noteEditingController.note;
  //   String? selectedPath = await FilePicker.platform.saveFile(fileName: "${note.title}.pdf");
  //
  //
  //   if (selectedPath != null) {
  //
  //     File file = File(selectedPath);
  //     await file.writeAsBytes(await note.toPDF().save());
  //   }
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
