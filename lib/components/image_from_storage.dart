import 'dart:io';

import 'package:amphi/utils/path_utils.dart';
import 'package:flutter/material.dart';

import '../models/app_storage.dart';

class ImageFromStorage extends StatelessWidget {
  final String filename;
  final String noteId;
  final BoxFit fit;
  const ImageFromStorage({super.key, this.fit = BoxFit.cover, required this.filename, required this.noteId});

  @override
  Widget build(BuildContext context) {

    String absolutePath = PathUtils.join(appStorage.attachmentsPath, noteId[0], noteId[1] , noteId, "images", filename);
    return Image.file(
      fit: fit,
      File(absolutePath)
    );
  }
}