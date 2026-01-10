import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/edit_style/edit_note_text_style.dart';
import 'package:amphi/widgets/menu/popup/custom_popup_menu_route.dart';
import 'package:notes/utils/screen_size.dart';

class NoteEditorTextStyleButton extends StatelessWidget {
  final QuillController controller;
  final double iconSize;
  const NoteEditorTextStyleButton({super.key, required this.controller, required this.iconSize});

  @override
  Widget build(BuildContext context) {

    return IconButton(
        icon: Icon(Icons.font_download, size: iconSize),
        onPressed: () {
          if(isTablet(context)) {
            showCustomPopupMenu(context, EditNoteTextStyle(controller: controller));
          }
          else {
            showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  enableDrag: true,
                  builder: (context) {
                    return EditNoteTextStyle(
                      controller: controller
                    );
                  });
          }
        });
  }
}
