
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/video/note_video.dart';

import '../../../../models/note.dart';

class VideoEmbedBuilder extends EmbedBuilder {
  final Note note;
  VideoEmbedBuilder(this.note);

  @override
  String get key => 'video';

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
   return NoteVideo(
     noteId: note.id,
     filename: embedContext.node.value.data
   );
  }
}