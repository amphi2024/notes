import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/utils/attachment_path.dart';

class NoteImage extends StatelessWidget {
  final String filename;
  final String noteId;
  final BoxFit fit;
  const NoteImage({super.key, this.fit = BoxFit.cover, required this.filename, required this.noteId});

  @override
  Widget build(BuildContext context) {

    return Image.file(
      fit: fit,
      File(noteImagePath(noteId, filename)),
      errorBuilder: (context, error, stackTrace) {
        appWebChannel.downloadNoteImage(id: noteId, filename: filename);
        return Image(image: NetworkImage("${appWebChannel.serverAddress}/notes/$noteId/images/$filename", headers: {"Authorization": appWebChannel.token}), fit: fit);
      },
    );
  }
}