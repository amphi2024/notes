import 'dart:convert';
import 'dart:io';

import 'package:amphi/utils/file_name_utils.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:sqflite/sqflite.dart';

import '../models/app_storage.dart';

Future<void> migrateThemes(Database db) async {
  final batch = db.batch();
  Directory directory = Directory(PathUtils.join(appStorage.selectedUser.storagePath, "themes"));
  List<FileSystemEntity> fileList = directory.listSync();

  for (FileSystemEntity file in fileList) {
    if (file is File) {
      String jsonString = file.readAsStringSync();
      Map<String, dynamic> jsonData = jsonDecode(jsonString);
      var id = FilenameUtils.nameOnly(PathUtils.basename(file.path));
      var data = {
        "id": id,
        "title": jsonData["title"],
        "created": jsonData["created"],
        "modified": jsonData["modified"],

        "background_light": jsonData["lightBackgroundColor"],
        "text_light": jsonData["lightTextColor"],
        "accent_light": jsonData["lightAccentColor"],
        "card_light": jsonData["lightNoteBackgroundColor"],
        "floating_button_background_light": jsonData["lightFloatingButtonBackground"],
        "floating_button_icon_light": jsonData["lightFloatingButtonIconColor"],

        "background_dark": jsonData["darkBackgroundColor"],
        "text_dark": jsonData["darkTextColor"],
        "accent_dark": jsonData["darkAccentColor"],
        "card_dark": jsonData["darkNoteBackgroundColor"],
        "floating_button_background_dark": jsonData["darkFloatingButtonBackground"],
        "floating_button_icon_dark": jsonData["darkFloatingButtonIconColor"]
      };

      batch.insert("themes", data);
    }
  }

  await batch.commit();
}