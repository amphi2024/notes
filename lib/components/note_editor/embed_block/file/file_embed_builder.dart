import 'package:amphi/utils/file_name_utils.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/file/file_block_widget.dart';
import 'package:notes/models/app_state.dart';

class FileEmbedBuilder extends EmbedBuilder {
  FileEmbedBuilder();

  @override
  String get key => 'file';

  @override
  Widget build(
      BuildContext context,
      QuillController controller,
      Embed node,
      bool readOnly,
      bool inline,
      TextStyle textStyle,
      ) {
    return FileBlockWidget(blockKey: node.value.data);
  }
}
