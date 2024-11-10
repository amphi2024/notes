import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/view_pager/view_pager_block_widget.dart';

class ViewPagerEmbedBuilder extends EmbedBuilder {
  @override
  String get key => 'view-pager';

  @override
  Widget build(
      BuildContext context,
      QuillController controller,
      Embed node,
      bool readOnly,
      bool inline,
      TextStyle textStyle,
      ) {
    return ViewPagerBlockWidget(viewPagerKey: node.value.data, readOnly: readOnly);
  }
}