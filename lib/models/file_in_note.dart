class FileInNote {
  String filename;
  String? originalPath;
  bool get uploaded => originalPath == null;

  FileInNote({required this.filename, this.originalPath});
}