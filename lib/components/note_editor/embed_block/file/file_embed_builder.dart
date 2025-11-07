import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/file/file_block_widget.dart';

class FileEmbedBuilder extends EmbedBuilder {
  FileEmbedBuilder();

  @override
  String get key => 'file';

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    return FileBlockWidget(filename: embedContext.node.value.data);
  }
}