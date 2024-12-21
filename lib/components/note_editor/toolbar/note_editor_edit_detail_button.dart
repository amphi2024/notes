import 'package:amphi/models/app.dart';
import 'package:amphi/widgets/menu/popup/custom_popup_menu_route.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/edit_note/edit_detail_dialog.dart';
import 'package:notes/components/note_editor/edit_style/edit_note_detail.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';

class NoteEditorEditDetailButton extends StatelessWidget {

  final NoteEditingController noteEditingController;
  final void Function(void Function()) onChange;
  const NoteEditorEditDetailButton({super.key, required this.noteEditingController, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.more_vert_rounded),
      onPressed: () {
        if(App.isWideScreen(context)) {
          showCustomPopupMenu(context, EditNoteDetail(noteEditingController: noteEditingController, onChange: onChange,));
        }
        else {
          showDialog(context: context, builder: (context) {
            return EditDetailDialog(noteEditingController: noteEditingController, onChange: onChange,);
          });
        }

      },
    );
  }
}
