
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/video/video_player_widget.dart';

class VideoEmbedBuilder extends EmbedBuilder {

  VideoEmbedBuilder();

  @override
  String get key => 'video';

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
   return VideoPlayerWidget(
     // noteFileNameOnly: FilenameUtils.nameOnly(appState.noteEditingController.note.filename),
     noteFileNameOnly: "",
     videoFilename: embedContext.node.value.data
   );
  }
}