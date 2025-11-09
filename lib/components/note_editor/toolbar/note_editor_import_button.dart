import 'package:amphi/models/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/icons/icons.dart';

import '../../../models/note.dart';
import '../../../utils/note_import_utils.dart';

class NoteEditorImportButton extends ConsumerWidget {
  final Note note;
  final QuillController controller;

  const NoteEditorImportButton({super.key, required this.controller, required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
        icon: Icon(AppIcons.import, size: 20),
        tooltip: AppLocalizations.of(context).get("import"),
        onPressed: () async {
          final selectedFiles = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.custom, allowedExtensions: ["note", "md"]);
          final file = selectedFiles?.files.firstOrNull;
          if (file != null) {
            final fileContent = await file.xFile.readAsString();
            if (file.extension == "note") {
              controller.importNote(noteId: note.id, fileContent: fileContent, ref: ref);
            }
            else if (file.extension == "md") {
              controller.importMarkdown(fileContent);
            }
          }
        });
  }
}