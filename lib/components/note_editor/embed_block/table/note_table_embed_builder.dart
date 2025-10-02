import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/table/note_table_widget.dart';

class NoteTableEmbedBuilder extends EmbedBuilder {

  NoteTableEmbedBuilder();

  @override
  String get key => 'table';

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    return NoteTableWidget(tableKey: embedContext.node.value.data, readOnly: embedContext.readOnly);
  }

}

