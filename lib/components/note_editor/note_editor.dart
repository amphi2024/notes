import 'dart:async';

import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/divider/divider_embed_builder.dart';
import 'package:notes/components/note_editor/embed_block/file/file_embed_builder.dart';
import 'package:notes/components/note_editor/embed_block/image/image_embed_builder.dart';
import 'package:notes/components/note_editor/embed_block/sub_note/sub_note_embed_builder.dart';
import 'package:notes/components/note_editor/embed_block/table/note_table_embed_builder.dart';
import 'package:notes/components/note_editor/embed_block/video/video_embed_builder.dart';
import 'package:notes/components/note_editor/embed_block/view_pager/view_pager_embed_builder.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/components/note_editor/note_editor_check_box_builder.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_file_button.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_sub_note_button.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_image_button.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_text_style_button.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_divider_button.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_table_button.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_video_button.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/note.dart';

import 'toolbar/note_editor_edit_detail_button.dart';

class NoteEditor extends StatefulWidget {

  final NoteEditingController noteEditingController;

  const NoteEditor(
      {super.key, required this.noteEditingController});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  FocusNode focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final TextStyle defaultTextStyle = Theme.of(context).textTheme.bodyMedium!;
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Note note = widget.noteEditingController.note;
    final TextStyle textStyle =     TextStyle(
        color: note.textColorByTheme(isDarkMode) ?? defaultTextStyle.color,
        fontSize: note.textSize ?? defaultTextStyle.fontSize,
    fontFamily: note.font);

    return QuillEditor(
      controller: widget.noteEditingController,
      config: QuillEditorConfig(
        autoFocus: false,
        placeholder: AppLocalizations.of(context).get("@new_note"),
        customStyles: DefaultStyles(
          paragraph: DefaultTextBlockStyle(
            textStyle,
            HorizontalSpacing(
              1, 1
          ),
            VerticalSpacing(
                note.lineHeight ?? 1, note.lineHeight ?? 1
            ),
            VerticalSpacing(
              1,  1
            ),
            BoxDecoration(),),
          lists: DefaultListBlockStyle(
            textStyle,
            HorizontalSpacing(
              1, 1
            ),
            VerticalSpacing(
                1, 1
            ),
              VerticalSpacing(
                  1,  1
              ),
            BoxDecoration(),
              NoteEditorCheckboxBuilder()
          )
        ),
        showCursor: !widget.noteEditingController.readOnly,
        embedBuilders: [
          ImageEmbedBuilder(),
          VideoEmbedBuilder(),
          NoteTableEmbedBuilder(),
          SubNoteEmbedBuilder(),
          DividerEmbedBuilder(),
          ViewPagerEmbedBuilder(),
          FileEmbedBuilder()
        ],
      ),
      focusNode: focusNode,
      scrollController: scrollController,
    );
  }
}


List<Widget> noteEditorToolbarButtons(NoteEditingController noteEditingController, void Function(void Function()) onNoteDetailChanged) {
  return  [
    NoteEditorTextStyleButton(noteEditingController: noteEditingController),
    NoteEditorImageButton(noteEditingController: noteEditingController),
    NoteEditorTableButton(noteEditingController: noteEditingController),
    NoteEditorFileButton(noteEditingController: noteEditingController),
    NoteEditorVideoButton(noteEditingController: noteEditingController),
    NoteEditorSubNoteButton(noteEditingController: noteEditingController),
    NoteEditorDividerButton(noteEditingController: noteEditingController),
    NoteEditorEditDetailButton(noteEditingController: noteEditingController, onChange: onNoteDetailChanged),
    //NoteEditorViewPagerButton(noteEditingController: noteEditingController),
    //  NoteEditorFileButton(noteEditingController: appState.noteEditingController),
    // NoteEditorChartButton(noteEditingController: appState.noteEditingController),
    // NoteEditorMindMapButton(noteEditingController: appState.noteEditingController),
    // NoteEditorAudioButton(noteEditingController: appState.noteEditingController),
  ];
}