import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/image/image_block_widget.dart';

class ImageEmbedBuilder extends EmbedBuilder {
  ImageEmbedBuilder();

  @override
  String get key => 'image';

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    // return ImageBlockWidget(noteName: FilenameUtils.nameOnly(appState.noteEditingController.note.filename), imageFilename: embedContext.node.value.data,
    // readOnly: embedContext.readOnly);
    return ImageBlockWidget(noteName: "", imageFilename: embedContext.node.value.data,
        readOnly: embedContext.readOnly);
  }
}
