import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/providers/editing_note_provider.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:notes/utils/document_conversion.dart';
import 'package:notes/utils/generate_id.dart';

import '../models/note.dart';
import 'note_editor/toolbar/note_editor_detail_button.dart';
import 'note_editor/toolbar/note_editor_export_button.dart';
import 'note_editor/toolbar/note_editor_import_button.dart';
import 'note_editor/toolbar/note_editor_redo_button.dart';
import 'note_editor/toolbar/note_editor_undo_button.dart';

List<Widget> notePageAppbarActions(
    {required BuildContext context,
    required WidgetRef ref,
    required Note note,
    required QuillController controller,
    required bool editing,
    required void Function() onSave}) {
  if (!editing) {
    return [
      NoteEditorExportButton(controller: controller),
      NoteEditorDetailButton(controller: controller),
      IconButton(
          onPressed: () {
            controller.readOnly = false;
            ref.read(editingNoteProvider.notifier).setEditing(true);
            // appState.note.getDraft((draftNote) {
            //   appState.startDraftSave();
            //   if(draftNote != null) {
            //     showDialog(context: context, builder: (context) {
            //       return DraftDialog(
            //         onCanceled: () {
            //           setState(() {
            //             controller.readOnly = false;
            //           });
            //         },
            //         onConfirmed: () {
            //           note.contents = draftNote.contents;
            //           controller.setNote(note);
            //           setState(() {
            //             controller.readOnly = false;
            //           });
            //         },
            //       );
            //     });
            //   }
            //   else {
            //     setState(() {
            //       controller.readOnly = false;
            //     });
            //   }
            // });
          },
          icon: Icon(
            Icons.edit,
            size: 25,
          ))
    ];
  }
  else {
    return [
      NoteEditorImportButton(controller: controller),
      NoteEditorUndoButton(controller: controller),
      NoteEditorRedoButton(controller: controller),
      IconButton(
          onPressed: onSave,
          icon: Icon(
            Icons.check_circle_outline,
            size: 25,
          ))
    ];
  }
}

void saveNote({required BuildContext context,
required WidgetRef ref,
required Note note,
required QuillController controller,
required bool editing}) async {
  if(note.id.isEmpty) {
    note.id = await generatedNoteId();
  }
  note.save();
  ref.read(notesProvider.notifier).insertNote(note);
}
