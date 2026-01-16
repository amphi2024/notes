import 'package:notes/utils/attachment_path.dart';

enum ThumbnailType {
  image, video, table
}

class ThumbnailData {
  final String noteId;
  final String filename;
  final String directoryName;
  final ThumbnailType type;
  ThumbnailData({required this.noteId, required this.directoryName, required this.filename, required this.type});

  String? get filePath => type != ThumbnailType.table ? noteAttachmentPath(noteId, filename, directoryName) : null;
}