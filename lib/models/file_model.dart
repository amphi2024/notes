import 'package:notes/models/content.dart';

class FileModel {
  String filename;
  String? originalPath;
  String label;
  bool get uploaded => originalPath == null;

  FileModel({required this.filename, this.originalPath, required this.label});

  static FileModel fromContent(Content content) {
    try {
      return FileModel(filename: content.value["filename"], label:  content.value["label"]);
    }
    catch(e) {
      return FileModel(filename: "not found", label: "not found");
    }
  }

  Content toContent() {
    return Content({
      "value": {"label": label, "filename": filename},
      "type": "file"
    });
  }
}