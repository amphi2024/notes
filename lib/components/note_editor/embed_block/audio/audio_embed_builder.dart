import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/audio/audio_block.dart';
import 'package:notes/models/note.dart';

class AudioEmbedBuilder extends EmbedBuilder {
  final Note note;
  AudioEmbedBuilder(this.note);

  @override
  String get key => 'audio';

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    return AudioBlock(noteId: note.id, filename: embedContext.node.value.data);
  }
}