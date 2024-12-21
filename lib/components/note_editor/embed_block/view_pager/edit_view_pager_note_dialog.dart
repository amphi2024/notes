import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/components/note_editor/note_editor.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_redo_button.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_undo_button.dart';

class EditViewPagerNoteDialog extends StatefulWidget {

  final NoteEditingController noteEditingController;
  const EditViewPagerNoteDialog({super.key, required this.noteEditingController});

  @override
  State<EditViewPagerNoteDialog> createState() => _EditViewPagerNoteDialogState();
}

class _EditViewPagerNoteDialogState extends State<EditViewPagerNoteDialog> {
  @override
  Widget build(BuildContext context) {
    widget.noteEditingController.readOnly = false;
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
                  NoteEditorUndoButton(noteEditingController: widget.noteEditingController),
                  NoteEditorRedoButton(noteEditingController: widget.noteEditingController),
                  IconButton(icon: Icon(Icons.check_circle_outline), onPressed: () {
                    Navigator.pop(context);
                    widget.noteEditingController.readOnly = true;
                  })
                ],
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
