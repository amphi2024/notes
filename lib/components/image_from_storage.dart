import 'dart:io';

import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:flutter/material.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/channels/app_web_download.dart';
import 'package:notes/models/app_storage.dart';

class ImageFromStorage extends StatelessWidget {
  final String imageFilename;
  final String noteName;
  final BoxFit fit;
  const ImageFromStorage({super.key, this.fit = BoxFit.cover, required this.imageFilename, required this.noteName});

  @override
  Widget build(BuildContext context) {

    String absolutePath = PathUtils.join(appStorage.notesPath, noteName, "images", imageFilename);
    return Image.file(
      fit: fit,
      File(absolutePath),
      errorBuilder: (context, object, stack) {
        appWebChannel.downloadImage( noteName: noteName, filename: imageFilename);
        return Image(
          fit: fit,
          image: NetworkImage("${appWebChannel.serverAddress}/notes/${noteName}/images/${imageFilename}",
              headers: {
                "Authorization": appWebChannel.token
              }
          ),
          errorBuilder: (context, obj, stack) {
            return Text(AppLocalizations.of(context).get("@message_cannot_load_image"));
          },
        );
      },
    );
  }
}
