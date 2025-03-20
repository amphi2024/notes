import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/file/file_block_widget.dart';

class FileEmbedBuilder extends EmbedBuilder {
  FileEmbedBuilder();

  @override
  String get key => 'file';

  // @override
  // Widget build(BuildContext context, EmbedContext embedContext) {
  //   return FileBlockWidget(blockKey: embedContext.node.value.data);
  // }

@override
  Widget build(BuildContext context, QuillController controller, Embed node, bool readOnly, bool inline, TextStyle textStyle) {
  return FileBlockWidget(blockKey: node.value.data);
  }
}
