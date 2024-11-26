import 'dart:io';

import 'package:amphi/utils/path_utils.dart';
import 'package:flutter/material.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/channels/app_web_download.dart';
import 'package:notes/models/app_storage.dart';

class ImageFromStorage extends StatelessWidget {
  final String imageFilename;
  final String noteFileNameOnly;
  final BoxFit fit;
  const ImageFromStorage({super.key, this.fit = BoxFit.cover, required this.imageFilename, required this.noteFileNameOnly});

  @override
  Widget build(BuildContext context) {

    String absolutePath = PathUtils.join(appStorage.notesPath, noteFileNameOnly, "images", imageFilename);
    return Image.file(
      fit: fit,
      File(absolutePath),
      errorBuilder: (context, object, stack) {
        if(!File(absolutePath).existsSync()) {
          appWebChannel.downloadImage( noteFileNameOnly: noteFileNameOnly, imageFilename: imageFilename);
        }
        return Image(
          image: NetworkImage("${appWebChannel.serverAddress}/notes/${noteFileNameOnly}/images/${imageFilename}",
              headers: {
                "Authorization": appWebChannel.token
              }
          ),
        );
      },
    );
  }
}
