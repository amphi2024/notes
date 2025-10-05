import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/note_editor.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_import_button.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_redo_button.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_undo_button.dart';

import '../../note_editor_toolbar.dart';

class EditSubNoteDialog extends StatefulWidget {

  final QuillController controller;
  const EditSubNoteDialog({super.key, required this.controller});

  @override
  State<EditSubNoteDialog> createState() => _EditSubNoteDialogState();
}

class _EditSubNoteDialogState extends State<EditSubNoteDialog> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      onPopInvokedWithResult: (canPop, result) {
        widget.controller.readOnly = true;
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Container(
          width: screenWidth > 200 ? 400 : screenWidth - 30,
          height: screenHeight > 600 ? 600 : screenHeight - 100,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  NoteEditorImportButton(controller: widget.controller),
                  NoteEditorUndoButton(controller: widget.controller),
                  NoteEditorRedoButton(controller: widget.controller),
                  IconButton(icon: Icon(Icons.check_circle_outline), onPressed: () {
                    Navigator.pop(context);
                    widget.controller.readOnly = true;
                  })
                ],
              ),
              // Expanded(child: Padding(
              //   padding: const EdgeInsets.all(7.5),
              //   child: NoteEditor(controller: controller),
              // )),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: noteEditorToolbarButtons(widget.controller, (function) => setState(function)),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
