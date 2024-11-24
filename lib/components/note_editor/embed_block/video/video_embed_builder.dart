
import 'package:amphi/utils/file_name_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/video/video_player_widget.dart';
import 'package:notes/models/app_state.dart';

class VideoEmbedBuilder extends EmbedBuilder {

  VideoEmbedBuilder();

  @override
  String get key => 'video';

  //VideoPlayerController? videoPlayerController;

  @override
  Widget build(
      BuildContext context,
      QuillController controller,
      Embed node,
      bool readOnly,
      bool inline,
      TextStyle textStyle,
      ) {
   return VideoPlayerWidget(
     noteFileNameOnly: FilenameUtils.nameOnly(appState.noteEditingController.note.filename),
     videoFilename: node.value.data
   );



  }
}