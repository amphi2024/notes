import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/divider/divider_block_widget.dart';

class DividerEmbedBuilder extends EmbedBuilder {

  DividerEmbedBuilder();

  @override
  String get key => 'divider';

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    return DividerBlockWidget(dividerKey: embedContext.node.value.data, readOnly: embedContext.readOnly);
  }

}