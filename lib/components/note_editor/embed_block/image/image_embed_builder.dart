import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/image/image_block_widget.dart';
import 'package:notes/models/app_state.dart';

class ImageEmbedBuilder extends EmbedBuilder {

  ImageEmbedBuilder();

  @override
  String get key => 'image';

  @override
  Widget build(
      BuildContext context,
      QuillController controller,
      Embed node,
      bool readOnly,
      bool inline,
      TextStyle textStyle,
      ) {
    return ImageBlockWidget(
      noteFileNameOnly: appState.noteEditingController.note.filename.split(".").first,
        imageFilename: node.value.data
    );
  }
}