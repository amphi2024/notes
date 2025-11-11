import 'dart:convert';
import 'dart:io';

import 'package:amphi/utils/file_name_utils.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:sqflite/sqflite.dart';

import '../models/app_storage.dart';

Future<void> migrateThemes(Database db) async {
  final batch = db.batch();
  Directory directory = Directory(PathUtils.join(appStorage.selectedUser.storagePath, "themes"));
  if (!await directory.exists()) {
    return;
  }
  List<FileSystemEntity> fileList = directory.listSync();

  for (FileSystemEntity file in fileList) {
    if (file is File) {
      var data = _parsedLegacyTheme(file);

      batch.insert("themes", data);
    }
  }

  await batch.commit();
}

Map<String, dynamic> _parsedLegacyTheme(File file) {
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

  return data;
}

Future<void> verifyThemesMigration(Database db) async {
  Directory themesDirectory = Directory(PathUtils.join(appStorage.selectedUser.storagePath, "themes"));
  if (!await themesDirectory.exists()) {
    return;
  }
  bool allDataMigrated = true;

  final themeFileList = themesDirectory.listSync();
  for (int i = 0; i < themeFileList.length; i++) {
    FileSystemEntity file = themeFileList[i];
    if (file is File) {
      var id = FilenameUtils.nameOnly(PathUtils.basename(file.path));
      final list = await db.rawQuery("SELECT * FROM themes WHERE id = ?;", [id]);
      if (list.isEmpty) {
        allDataMigrated = false;
        final data = _parsedLegacyTheme(file);
        await db.insert("themes", data);
      }
    }

    if (allDataMigrated) {
      await themesDirectory.delete(recursive: true);
    }
  }
}