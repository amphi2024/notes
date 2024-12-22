import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/components/note_editor/note_editor.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_import_button.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_redo_button.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_undo_button.dart';

class EditSubNoteDialog extends StatefulWidget {

  final NoteEditingController noteEditingController;
  const EditSubNoteDialog({super.key, required this.noteEditingController});

  @override
  State<EditSubNoteDialog> createState() => _EditSubNoteDialogState();
}

class _EditSubNoteDialogState extends State<EditSubNoteDialog> {

  late TextEditingController textEditingController = TextEditingController(text: widget.noteEditingController.note.title);

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
   textEditingController.addListener(() {
     widget.noteEditingController.note.title = textEditingController.text;
   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      onPopInvokedWithResult: (canPop, result) {
        widget.noteEditingController.readOnly = true;
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
                  NoteEditorImportButton(noteEditingController: widget.noteEditingController),
                  NoteEditorUndoButton(noteEditingController: widget.noteEditingController),
                  NoteEditorRedoButton(noteEditingController: widget.noteEditingController),
                  IconButton(icon: Icon(Icons.check_circle_outline), onPressed: () {
                    Navigator.pop(context);
                    widget.noteEditingController.readOnly = true;
                  })
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7.5, right: 7.5),
                child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: AppLocalizations.of(context).get("@editor_hint_sub_note_title"),
                    hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                    focusedBorder: InputBorder.none
                  ),
                ),
              ),
              Expanded(child: Padding(
                padding: const EdgeInsets.all(7.5),
                child: NoteEditor(noteEditingController: widget.noteEditingController),
              )),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: noteEditorToolbarButtons(widget.noteEditingController, (function) => setState(function)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
