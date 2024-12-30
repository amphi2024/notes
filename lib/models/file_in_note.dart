import 'package:notes/models/content.dart';

class FileInNote {
  String filename;
  String? originalPath;
  String label;
  bool get uploaded => originalPath == null;

  FileInNote({required this.filename, this.originalPath, required this.label});

  static FileInNote fromContent(Content content) {
    try {
      return FileInNote(filename: content.value["filename"], label:  content.value["label"]);
    }
    catch(e) {
      return FileInNote(filename: "not found", label: "not found");
    }
  }

  Content toContent() {
    return Content(
      value: {
        "label": label,
        "filename": filename
      },
      type: "file"
    );
  }
}