import 'package:flutter/material.dart';
import 'package:notes/components/note_image.dart';

class NoteImageRounded extends StatelessWidget {

  final BorderRadiusGeometry borderRadius;
  final String noteId;
  final String filename;
  const NoteImageRounded({super.key, required this.borderRadius, required this.noteId, required this.filename});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: NoteImage(filename: filename, noteId: noteId),
    );
  }
}