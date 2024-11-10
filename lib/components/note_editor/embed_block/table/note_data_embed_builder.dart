import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/table/note_data_widget.dart';

class NoteDataEmbedBuilder extends EmbedBuilder {

  NoteDataEmbedBuilder();

  @override
  String get key => 'data';

  @override
  Widget build(
      BuildContext context,
      QuillController controller,
      Embed node,
      bool readOnly,
      bool inline,
      TextStyle textStyle,
      ) {

    return NoteDataWidget(tableKey: node.value.data, readOnly: readOnly);
  }
}

