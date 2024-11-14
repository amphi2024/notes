import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/table/note_table_widget.dart';

class NoteTableEmbedBuilder extends EmbedBuilder {

  NoteTableEmbedBuilder();

  @override
  String get key => 'table';

  @override
  Widget build(
      BuildContext context,
      QuillController controller,
      Embed node,
      bool readOnly,
      bool inline,
      TextStyle textStyle,
      ) {

    return NoteTableWidget(tableKey: node.value.data, readOnly: readOnly);
  }
}

