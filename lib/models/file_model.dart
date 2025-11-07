class FileModel {
  String filename;
  String? originalPath;
  String label;
  bool get uploading => originalPath != null;
  bool downloading = false;
  int total = 0;
  int transferred = 0;

  FileModel({required this.filename, this.originalPath, required this.label});

}