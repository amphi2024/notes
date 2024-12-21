import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/widgets/menu/popup/show_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/models/note.dart';

class NoteEditorImportButton extends StatelessWidget {

  final NoteEditingController noteEditingController;
  const NoteEditorImportButton({super.key, required this.noteEditingController});

  void importFromNote() async {
    Note note = noteEditingController.note;
    String? selectedPath = await FilePicker.platform.saveFile(fileName: "${note.title}.note");

  }

  void importFromHTML() async {
    Note note = noteEditingController.note;
    String? selectedPath = await FilePicker.platform.saveFile(fileName: "${note.title}.html");


  }

  void importFromMarkdown() async {
    Note note = noteEditingController.note;
    String? selectedPath = await FilePicker.platform.saveFile(fileName: "${note.title}.md");

  }

  void importFromWord() async {
    Note note = noteEditingController.note;
    String? selectedPath = await FilePicker.platform.saveFile(fileName: "${note.title}.html");

    if (selectedPath != null) {

    }
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    return IconButton(
      icon: Icon(Icons.import_contacts),
      onPressed: () {
        showMenuByRelative(context: context, items: [
          PopupMenuItem(child: Text(localizations.get("@note_export_label_note")), onTap: importFromNote),
          PopupMenuItem(child: Text(localizations.get("@note_export_label_html")), onTap: importFromHTML),
          PopupMenuItem(child: Text(localizations.get("@note_export_label_markdown")), onTap: importFromMarkdown),
          PopupMenuItem(child: Text(localizations.get("@note_export_label_word")), onTap: importFromWord),
          // PopupMenuItem(child: Text(localizations.get("@note_export_label_pdf")), onTap: exportAsPDF),
        ]);
      },
    );
  }
}