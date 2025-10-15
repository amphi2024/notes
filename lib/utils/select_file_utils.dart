import 'dart:convert';
import 'dart:io';
import 'package:amphi/utils/file_name_utils.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:file_picker/file_picker.dart';

import '../models/app_storage.dart';

Future<List<File>> selectedImageFiles(String noteId) async {
  final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowMultiple: true, allowedExtensions: [ "webp", "jpg", "jpeg", "png", "gif", "bmp", "tiff", "tif", "svg",
    "ico", "heic", "heif", "jfif", "pjpeg", "pjp", "avif",
    "raw", "dng", "cr2", "nef", "arw", "rw2", "orf", "sr2", "raf", "pef"]);
  List<File> list = [];
  if (result?.files.isNotEmpty ?? false) {
    for(var file in result!.files) {
      list.add(await createdImageFile(noteId, file.path!));
    }
  }

  return list;

}

Future<File?> selectedVideoFile(String noteId) async {
  final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: [
    "mp4", "mov", "avi", "wmv", "mkv", "flv", "webm", "mpeg", "mpg", "m4v", "3gp", "3g2", "f4v", "swf", "vob", "ts"
  ],
      allowMultiple: false
  );

  if (result?.files.isNotEmpty ?? false) {
    final selectedFile = result!.files.first;

    if (selectedFile.path != null) {
      return createdVideoFile(noteId, selectedFile.path!);
    } else {
      return null;
    }
  } else {
    return null;
  }
}

Future<File> createdFileWithBase64(String id, String base64, String fileExtension ,String directoryName) async {
  Directory directory = Directory(PathUtils.join(appStorage.attachmentsPath, id[0], id[1], directoryName));
  if (!directory.existsSync()) {
    await directory.create(recursive: true);
  }

  String generatedImageFilename = FilenameUtils.generatedFileName(fileExtension, directory.path);

  File file = File(PathUtils.join(directory.path, generatedImageFilename));
  await file.writeAsBytes(base64Decode(base64));

  return file;
}

Future<File> createdFile(String id, String originalPath, String directoryName) async {
  Directory directory = Directory(PathUtils.join(appStorage.attachmentsPath, id[0], id[1], id, directoryName));
  if (!directory.existsSync()) {
    await directory.create(recursive: true);
  }

  String generatedImageFilename = FilenameUtils.generatedFileName(PathUtils.extension(originalPath), directory.path);

  File originalFile = File(originalPath);
  File file = File(PathUtils.join(directory.path, generatedImageFilename));
  await originalFile.copy(file.path);

  return file;
}

Future<File> createdImageFile(String id, String originalPath) async => createdFile(id, originalPath, "images");

Future<File> createdVideoFile(String id, String originalPath) async => createdFile(id, originalPath, "videos");

Future<File> createdImageFileWithBase64(String id, String base64, String fileExtension) async => createdFileWithBase64(id, base64, fileExtension , "images");

Future<File> createdVideoFileWithBase64(String id,String base64, String fileExtension) async => createdFileWithBase64(id, base64, fileExtension , "videos");