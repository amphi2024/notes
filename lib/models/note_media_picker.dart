import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:notes/models/note.dart';

// class NoteMediaPicker {
//   static Future<File?> selectedImageFile(Note note) async {
//
//     final result = await FilePicker.platform
//         .pickFiles(type: FileType.image);
//
//     if (result?.files.isNotEmpty ?? false) {
//       final selectedFile = result!.files.first;
//
//       if (selectedFile.path != null) {
//       //  return Note.createdImageFile(note, selectedFile.path!);
//       }
//       else {
//         return null;
//       }
//     }
//     else {
//       return null;
//     }
//   }
//
//   static Future<File?> selectedVideoFile() async {
//     final result = await FilePicker.platform
//         .pickFiles(type: FileType.video);
//
//     if (result?.files.isNotEmpty ?? false) {
//       final selectedFile = result!.files.first;
//
//       if (selectedFile.path != null) {
//         return Note.createdVideoFile(selectedFile.path!);
//       }
//       else {
//         return null;
//       }
//     }
//     else {
//       return null;
//     }
//   }
// }