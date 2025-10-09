import 'dart:convert';
import 'dart:io';

import 'package:amphi/utils/file_name_utils.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:sqflite/sqflite.dart';

import '../models/app_storage.dart';

Future<void> moveAttachments(String oldId, String id) async {
  var directory = Directory(PathUtils.join(appStorage.selectedUser.storagePath, "notes", oldId));
  if(await directory.exists() && id.length > 2) {
    await Directory(PathUtils.join(appStorage.selectedUser.storagePath, "attachments", id[0] , id[1])).create(recursive: true);
    await directory.rename(PathUtils.join(appStorage.selectedUser.storagePath, "attachments", id[0] , id[1], id));
  }
}

Future<void> migrateNotes(Database db) async {
  final batch = db.batch();
  Directory directory = Directory(PathUtils.join(appStorage.selectedUser.storagePath, "notes"));
  if(!await directory.exists()) {
    return;
  }

  List<FileSystemEntity> fileList = directory.listSync();

  for (int i = 0; i < fileList.length; i++) {
    FileSystemEntity file = fileList[i];
    if (file is File) {
       var oldId = FilenameUtils.nameOnly(PathUtils.basename(file.path));
      Map<String, dynamic> map = jsonDecode(await file.readAsString());

      if (file.path.endsWith(".note")) {
        var id = "${oldId}legacynote";

          var data = _parsedLegacyNote(id, map);
          batch.insert("notes", data);
          moveAttachments(oldId, id);
      } else if (file.path.endsWith(".folder")) {
        var id = "${oldId}legacyfolder";
        var data = _parsedLegacyFolder(id, map);
        batch.insert("notes", data);
      }
    }
  }

  batch.commit();
}

Map<String, dynamic> _parsedLegacyNote(String id, Map<String, dynamic> map) {
  var data = _parsedLegacyData(id, map);
  data["is_folder"] = 0;
  data["content"] = jsonEncode(map["contents"]);

  return data;
}

Map<String, dynamic> _parsedLegacyFolder(String id, Map<String, dynamic> map) {
  var data = _parsedLegacyData(id, map);
  data["is_folder"] = 1;
  data["title"] = map["name"];

  return data;
}


Map<String, dynamic> _parsedLegacyData(String id, Map<String, dynamic> map) {
  final String location = map["location"];
  final parentId = location.split(".folder").firstOrNull;
  var data = {
    "id": id,
    "created": map["created"],
    "modified": map["modified"]
  };

  if(map["deleted"] is int) {
    data["deleted"] = map["deleted"];
  }

  if(parentId != null && parentId.isNotEmpty) {
    data["parent_id"] = "${parentId}legacyfolder";
  }

  if(map["lineHeight"] is int) {
    data["line_height"] = map["lineHeight"];
  }

  if(map["textSize"] is int) {
    data["text_size"] = map["textSize"];
  }

  if(map["textColor"] is int) {
    data["text_color"] = map["textColor"];
  }

  if(map["textColor"] is int) {
    data["text_color"] = map["textColor"];
  }

  if(map["backgroundColor"] is int) {
    data["background_color"] = map["backgroundColor"];
  }

  return data;
}