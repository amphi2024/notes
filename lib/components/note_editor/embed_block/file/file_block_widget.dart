import 'package:flutter/material.dart';

class FileBlockWidget extends StatelessWidget {

  final String filename;
  final String noteFileNameOnly;
  final String? originalFilePath;
  const FileBlockWidget({super.key, required this.filename, required this.noteFileNameOnly, this.originalFilePath});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}