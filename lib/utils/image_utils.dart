import 'dart:io';

import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/utils/file_name_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:notes/utils/toast.dart';
import 'package:share_plus/share_plus.dart';

import 'attachment_path.dart';

void shareNoteImage(String noteId, String filename) async {
  final params = ShareParams(
    files: [XFile(noteImagePath(noteId, filename))],
  );

  await SharePlus.instance.share(params);
}

void exportNoteImage(String noteId, String filename, BuildContext context) async {
  final originalFile = File(noteImagePath(noteId, filename));
  var bytes = await originalFile.readAsBytes();
  var selectedPath = await FilePicker.platform.saveFile(
      fileName: "image.${FilenameUtils.extensionName(filename)}",
      bytes: bytes
  );
  if(selectedPath != null) {
    var file = File(selectedPath);
    await file.writeAsBytes(bytes);
    showToast(context, AppLocalizations.of(context).get("@toast_message_image_export_success"));
  }
}