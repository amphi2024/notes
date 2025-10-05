import 'package:amphi/models/app.dart';
import 'package:amphi/widgets/menu/popup/custom_popup_menu_route.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/edit_note/edit_detail_dialog.dart';
import 'package:notes/components/note_editor/edit_style/edit_note_detail.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NoteEditorEditDetailButton extends StatelessWidget {

  final QuillController controller;
  const NoteEditorEditDetailButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.more_vert_rounded),
      onPressed: () {
        if(App.isWideScreen(context)) {
          showCustomPopupMenu(context, EditNoteDetail(controller: controller));
        }
        else {
          showDialog(context: context, builder: (context) {
            return EditDetailDialog(noteEditingController: controller);
          });
        }

      },
    );
  }
}
