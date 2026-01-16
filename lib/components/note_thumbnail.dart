import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/models/thumbnail_data.dart';

import '../channels/app_web_channel.dart';

class NoteThumbnail extends StatelessWidget {

  final BorderRadiusGeometry borderRadius;
  final ThumbnailData thumbnailData;
  const NoteThumbnail({super.key, required this.borderRadius, required this.thumbnailData});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.file(
        fit: BoxFit.cover,
        File(thumbnailData.filePath!),
        errorBuilder: (context, error, stackTrace) {
          switch(thumbnailData.type) {
            case ThumbnailType.image:
              appWebChannel.downloadNoteImage(id: thumbnailData.noteId, filename: thumbnailData.filename);
              return Image(image: NetworkImage("${appWebChannel.serverAddress}/notes/${thumbnailData.noteId}/images/${thumbnailData.filename}", headers: {"Authorization": appWebChannel.token}), fit: BoxFit.cover);
            case ThumbnailType.video:
              return const SizedBox.shrink(); //TODO: display default icon image
            default:
              return const SizedBox.shrink(); //TODO: display default icon image
          }
        },
      ),
    );
  }
}