
import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/divider/divider_embed_builder.dart';
import 'package:notes/components/note_editor/embed_block/file/file_embed_builder.dart';
import 'package:notes/components/note_editor/embed_block/image/image_embed_builder.dart';
import 'package:notes/components/note_editor/embed_block/table/note_table_embed_builder.dart';
import 'package:notes/components/note_editor/embed_block/video/video_embed_builder.dart';
import 'package:notes/components/note_editor/note_editor_check_box_builder.dart';
import 'package:notes/models/note.dart';
import 'package:notes/utils/screen_size.dart';

import 'embed_block/audio/audio_embed_builder.dart';

class NoteEditor extends StatefulWidget {

  final Note note;
  final QuillController controller;
  final FocusNode focusNode;
  const NoteEditor({super.key, required this.note, required this.controller, required this.focusNode});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {

  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final TextStyle defaultTextStyle = Theme.of(context).textTheme.bodyMedium!;
    final TextStyle textStyle = TextStyle(
        color: widget.note.textColorByTheme(context) ?? defaultTextStyle.color,
        fontSize: widget.note.textSize ?? defaultTextStyle.fontSize);

    final editor = QuillEditor(
        controller: widget.controller,
        scrollController: scrollController,
        focusNode: widget.focusNode,
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
            VideoEmbedBuilder(widget.note),
            NoteTableEmbedBuilder(),
            AudioEmbedBuilder(widget.note),
            DividerEmbedBuilder(),
            FileEmbedBuilder()
          ],
        )
    );

    if(isDesktopOrTablet(context)) {
      return editor;
    }
    return CupertinoScrollbar(
      controller: scrollController,
      child: editor,
    );
  }
}

extension CodeStyleExtension on Color {

  Color toCodeBlockBackground() {
    final alpha = (a * 255).round() & 0xff;
    final red = (r * 255).round() & 0xff;
    final green = (g * 255).round() & 0xff;
    final blue = (b * 255).round() & 0xff;
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

  final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
  if(((backgroundColor.r * 255).round() & 0xff) + ((backgroundColor.b * 255).round() & 0xff) + ((backgroundColor.g * 255).round() & 0xff) < 375) {
    red = 93;
    green = 151;
    blue = 241;
  }

  return Color.fromARGB(240, red, green, blue);
}