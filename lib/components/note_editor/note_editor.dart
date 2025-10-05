
import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/divider/divider_embed_builder.dart';
import 'package:notes/components/note_editor/embed_block/file/file_embed_builder.dart';
import 'package:notes/components/note_editor/embed_block/image/image_embed_builder.dart';
import 'package:notes/components/note_editor/embed_block/sub_note/sub_note_embed_builder.dart';
import 'package:notes/components/note_editor/embed_block/table/note_table_embed_builder.dart';
import 'package:notes/components/note_editor/embed_block/video/video_embed_builder.dart';
import 'package:notes/components/note_editor/note_editor_check_box_builder.dart';
import 'package:notes/models/note.dart';

class NoteEditor extends StatefulWidget {

  final Note note;
  final QuillController controller;
  const NoteEditor({super.key, required this.note, required this.controller});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {

  @override
  Widget build(BuildContext context) {

    final TextStyle defaultTextStyle = Theme.of(context).textTheme.bodyMedium!;
    final TextStyle textStyle = TextStyle(
        color: widget.note.textColorByTheme(context) ?? defaultTextStyle.color,
        fontSize: widget.note.textSize ?? defaultTextStyle.fontSize);

    return QuillEditor(
      controller: widget.controller,
      scrollController: ScrollController(),
      focusNode: FocusNode(),
      config: QuillEditorConfig(
        autoFocus: false,
        placeholder: AppLocalizations.of(context).get("@new_note"),
        customStyles: DefaultStyles(
          code: DefaultTextBlockStyle(TextStyle(
              color: codeBlockTextColor(context),
              fontSize: 13,
            height: 1.15,
          ),
            HorizontalSpacing(
                1, 1
            ),
            VerticalSpacing(
                widget.note.lineHeight ?? 1, widget.note.lineHeight ?? 1
            ),
            VerticalSpacing(
                1,  1
            ),
            BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor.toCodeBlockBackground(),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          paragraph: DefaultTextBlockStyle(
            textStyle,
            HorizontalSpacing(
              1, 1
          ),
            VerticalSpacing(
                widget.note.lineHeight ?? 1, widget.note.lineHeight ?? 1
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
              NoteEditorCheckboxBuilder(),
          )
        ),
        showCursor: !widget.controller.readOnly,
        embedBuilders: [
          ImageEmbedBuilder(widget.note),
          VideoEmbedBuilder(),
          NoteTableEmbedBuilder(),
          SubNoteEmbedBuilder(),
          DividerEmbedBuilder(),
          FileEmbedBuilder()
        ],
      )
    );
  }
}

extension CodeStyleExtension on Color {

  Color toCodeBlockBackground() {
    if(red + blue + green > 375) {
      return Color.fromARGB(alpha, red - 5, green - 5, blue - 5);
    }
    else {
      return Color.fromARGB(alpha, red + 5, green + 5, blue + 5);
    }
  }
}

Color codeBlockTextColor(BuildContext context) {
  int red = 13;
  int green = 71;
  int blue = 161;

  var backgroundColor = Theme.of(context).scaffoldBackgroundColor;
  if(backgroundColor.red + backgroundColor.blue + backgroundColor.green < 375) {
    red = 93;
    green = 151;
    blue = 241;
  }

  return Color.fromARGB(240, red, green, blue);
}