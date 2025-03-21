import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/sub_note/sub_note_block_widget.dart';

class SubNoteEmbedBuilder extends EmbedBuilder {

  SubNoteEmbedBuilder();

  @override
  String get key => 'note';

  // @override
  // Widget build(BuildContext context, EmbedContext embedContext) {
  //   return SubNoteBlockWidget(
  //       noteKey: embedContext.node.value.data,
  //     readOnly: appState.noteEditingController.readOnly,
  //   );
  // }

   @override
  Widget build(BuildContext context, QuillController controller, Embed node, bool readOnly, bool inline, TextStyle textStyle) {
       return SubNoteBlockWidget(
           noteKey: node.value.data,
         readOnly: readOnly,
       );
  }
}