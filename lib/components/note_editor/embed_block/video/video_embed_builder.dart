
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/video/video_player_widget.dart';

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
    String filePath = node.value.data;

   return VideoPlayerWidget(
     path: filePath
   );



  }
}