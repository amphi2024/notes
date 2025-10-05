import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/image/image_block_widget.dart';
import 'package:notes/models/note.dart';

class ImageEmbedBuilder extends EmbedBuilder {
  final Note note;
  ImageEmbedBuilder(this.note);

  @override
  String get key => 'image';

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    return ImageBlockWidget(noteId: note.id, filename: embedContext.node.value.data,
        readOnly: embedContext.readOnly);
  }
}
