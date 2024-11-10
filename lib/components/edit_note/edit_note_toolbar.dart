import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_divider_button.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_edit_detail_button.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_image_button.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_sub_note_button.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_table_button.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_text_style_button.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_video_button.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_view_pager_button.dart';

class EditNoteToolbar extends StatefulWidget {
  final NoteEditingController noteEditingController;
  final void Function(void Function()) onNoteStyleChange;
  const EditNoteToolbar({super.key, required this.noteEditingController, required this.onNoteStyleChange});

  @override
  State<EditNoteToolbar> createState() => _EditNoteToolbarState();
}

class _EditNoteToolbarState extends State<EditNoteToolbar> {
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: PageView(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NoteEditorTextStyleButton(
                  noteEditingController: widget.noteEditingController),
              NoteEditorImageButton(
                  noteEditingController: widget.noteEditingController),
              NoteEditorTableButton(
                  noteEditingController: widget.noteEditingController),
              NoteEditorEditDetailButton(
                  noteEditingController: widget.noteEditingController, onChange: widget.onNoteStyleChange),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NoteEditorVideoButton(
                  noteEditingController: widget.noteEditingController),
              NoteEditorSubNoteButton(
                  noteEditingController: widget.noteEditingController),
              NoteEditorDividerButton(
                  noteEditingController: widget.noteEditingController),
              // NoteEditorFileButton(
              //     noteEditingController: widget.noteEditingController),
              NoteEditorViewPagerButton(
                  noteEditingController: widget.noteEditingController),
            ],
          ),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     NoteEditorFileButton(
          //         noteEditingController: widget.noteEditingController),
          //     NoteEditorChartButton(
          //         noteEditingController: widget.noteEditingController),
          //     NoteEditorMindMapButton(
          //         noteEditingController: widget.noteEditingController),
          //     NoteEditorAudioButton(
          //         noteEditingController: widget.noteEditingController),
          //   ],
          // ),
        ],
      ),
    );
  }
}
