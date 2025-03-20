import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/view_pager/view_pager_block_widget.dart';

class ViewPagerEmbedBuilder extends EmbedBuilder {
  @override
  String get key => 'view-pager';

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    return ViewPagerBlockWidget(viewPagerKey: embedContext.node.value.data, readOnly: embedContext.readOnly);
  }
}