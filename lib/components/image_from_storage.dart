import 'dart:io';

import 'package:amphi/utils/path_utils.dart';
import 'package:flutter/material.dart';

import '../models/app_storage.dart';


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
      File(absolutePath)
    );
  }
}
