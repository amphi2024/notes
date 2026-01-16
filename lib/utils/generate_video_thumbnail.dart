import 'dart:io';

import 'package:amphi/utils/file_name_utils.dart';
import 'package:notes/utils/attachment_path.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

Future<void> generateVideoThumbnail({required String noteId, required String filename}) async {
  final String filePath = noteAttachmentPath(noteId, "${FilenameUtils.nameOnly(filename)}_thumbnail.jpg", "videos");
  final videoFile = File(noteVideoPath(noteId, filename));
  // final thumbnailFile = File(filePath);

  if((Platform.isAndroid || Platform.isIOS) && videoFile.path.endsWith(".mp4")) {
    await VideoThumbnail.thumbnailFile(
      video: videoFile.path,
      thumbnailPath: filePath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 75,
    );
  }
  else {
    // TODO: implement fallback
  }
}