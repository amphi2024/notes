import 'package:amphi/models/app.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/edit_style/edit_note_text_style.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:amphi/widgets/menu/popup/custom_popup_menu_route.dart';

class NoteEditorTextStyleButton extends StatefulWidget {

  final NoteEditingController noteEditingController;
  const NoteEditorTextStyleButton({super.key, required this.noteEditingController});

  @override
  State<NoteEditorTextStyleButton> createState() => _NoteEditorTextStyleButtonState();
}

class _NoteEditorTextStyleButtonState extends State<NoteEditorTextStyleButton> {
  @override
  Widget build(BuildContext context) {

    return IconButton(
        icon: Icon(Icons.font_download),
        onPressed: () {
          if(App.isWideScreen(context)) {
            showCustomPopupMenu(context, EditNoteTextStyle(noteEditingController: widget.noteEditingController));
          }
          else {
            showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  enableDrag: true,
                  builder: (context) {
                    return EditNoteTextStyle(
                      noteEditingController: widget.noteEditingController,
                    );
                  });
          }
        });
  }
}
