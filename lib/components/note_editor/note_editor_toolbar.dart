import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'toolbar/note_editor_divider_button.dart';
import 'toolbar/note_editor_edit_detail_button.dart';
import 'toolbar/note_editor_file_button.dart';
import 'toolbar/note_editor_image_button.dart';
import 'toolbar/note_editor_sub_note_button.dart';
import 'toolbar/note_editor_table_button.dart';
import 'toolbar/note_editor_text_style_button.dart';
import 'toolbar/note_editor_video_button.dart';

class NoteEditorToolbar extends StatelessWidget {

  final QuillController controller;
  const NoteEditorToolbar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final buttons = noteEditorToolbarButtons(controller);
    return Container(
      height: 60,
      color: Theme.of(context).cardColor,
      child: PageView(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buttons[0],
              buttons[1],
              buttons[2],
              buttons[3],
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buttons[4],
              buttons[5],
              buttons[6],
              buttons[7],
            ],
          ),
        ],
      ),
    );
  }
}

List<Widget> noteEditorToolbarButtons(QuillController controller) {
  return  [
    NoteEditorTextStyleButton(controller: controller),
    NoteEditorImageButton(controller: controller),
    NoteEditorTableButton(controller: controller),
    NoteEditorFileButton(controller: controller),
    NoteEditorVideoButton(controller: controller),
    NoteEditorSubNoteButton(controller: controller),
    NoteEditorDividerButton(controller: controller),
    NoteEditorEditDetailButton(controller: controller)
  ];
}