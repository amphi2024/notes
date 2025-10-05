import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    required QuillController controller}) {
  if (controller.readOnly) {
    return [
      NoteEditorExportButton(controller: controller),
      NoteEditorDetailButton(controller: controller),
      IconButton(
          onPressed: () {
            if (controller.readOnly) {
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
            }
          },
          icon: Icon(
            Icons.edit,
            size: 25,
          ))
    ];
  }
  return [
    NoteEditorImportButton(controller: controller),
    NoteEditorUndoButton(controller: controller),
    NoteEditorRedoButton(controller: controller),
    IconButton(
        onPressed: () {
            // if (!widget.createNote) {
            //   setState(() {
            //     controller.readOnly = true;
            //   });
            // } else {
            //   controller.readOnly = true;
            //   Navigator.pop(context);
            // }
            // Note note = controller.getNote();
            // // Note note = Note.createdNote("");
            // widget.onSave(note);
        },
        icon: Icon(
          Icons.check_circle_outline,
          size: 25,
        ))
  ];
}
