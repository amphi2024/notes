
import 'package:flutter/material.dart';
import 'package:notes/components/image_from_storage.dart';

class ImageFromStorageRounded extends StatelessWidget {

  final BorderRadiusGeometry borderRadius;
  final String noteId;
  final String filename;
  const ImageFromStorageRounded({super.key, required this.borderRadius, required this.noteId, required this.filename});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: NoteImage(filename: filename, noteId: noteId),
    );
  }
}
