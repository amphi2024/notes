import 'dart:convert';
import 'dart:io';

import 'package:amphi/extensions/color_extension.dart';
import 'package:amphi/utils/file_name_utils.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:notes/channels/app_web_channel.dart';

import 'package:notes/models/item.dart';
import 'package:notes/models/note.dart';

import 'app_storage.dart';

class Folder extends Item {
  Folder(
      {required super.title,
      required super.filename,
      required super.path,
      required super.location,
      required super.created,
      required super.originalCreated,
      required super.modified,
      required super.originalModified,
      super.deleted});

  static Folder createdFolder(String location) {
    String filename = FilenameUtils.generatedFileName(".folder", appStorage.attachmentsPath);
    return Folder(
        title: "",
        filename: filename,
        path: PathUtils.join(appStorage.attachmentsPath, filename),
        location: location,
        created: DateTime.now(),
        originalCreated: DateTime.now(),
        modified: DateTime.now(),
        originalModified: DateTime.now());
  }

  Future<void> bringToFrontIfOrphan() async {
    if(location != "" && location != "!Trashes") {
      var folderFile = File(PathUtils.join(appStorage.attachmentsPath, location));
      if(! await folderFile.exists()) {
        location = "";
        save(upload: false, changeModified: false);
      }
    }
  }

  static Folder fromFile(File file) {
    try {
      String fileContent = file.readAsStringSync();
      Map<String, dynamic> map = jsonDecode(fileContent);
      // DateTime created = parsedDateTime(map["created"]);
      // DateTime originalCreated = parsedDateTime(map["originalCreated"]);
      // DateTime modified = parsedDateTime(map["modified"]);
      // DateTime originalModified = parsedDateTime(map["originalModified"]);

      DateTime created = DateTime.fromMillisecondsSinceEpoch(map["created"]).toLocal();
      DateTime originalCreated = DateTime.fromMillisecondsSinceEpoch(map["originalCreated"]).toLocal();
      DateTime modified = DateTime.fromMillisecondsSinceEpoch(map["modified"]).toLocal();
      DateTime originalModified = DateTime.fromMillisecondsSinceEpoch(map["originalModified"]).toLocal();



      DateTime? deleted;
      if (map["deleted"] != null) {
        // deleted = parsedDateTime(map["deleted"]);
        deleted = DateTime.fromMillisecondsSinceEpoch(map["deleted"]).toLocal();
      }
      Folder folder = Folder(
          filename: PathUtils.basename(file.path),
          title: map["name"],
          location: map["location"] ?? "",
          path: file.path,
          created: created,
          modified: modified,
          originalCreated: originalCreated,
          originalModified: originalModified,
          deleted: deleted);
      return folder;
    } catch (e) {
      Folder folder = Folder(
          title: "unknown",
          filename: "",
          location: "",
          path: file.path,
          created: DateTime.now(),
          modified: DateTime.now(),
          originalCreated: DateTime.now(),
          originalModified: DateTime.now());
      return folder;
    }
  }

  String toFileContent() {
    Map<String, dynamic> data = {
      "name": title,
      "location": location,
      "created": created.toUtc().millisecondsSinceEpoch,
      "modified": modified.toUtc().millisecondsSinceEpoch,
      "originalCreated": originalCreated.toUtc().millisecondsSinceEpoch,
      "originalModified": originalModified.toUtc().millisecondsSinceEpoch,
    };
    if (backgroundColor != null) {
      data.addAll({"backgroundColor": backgroundColor!.toHex()});
    }
    if (deleted != null) {
      data.addAll({"deleted": deleted!.toUtc().millisecondsSinceEpoch});
    }
    String fileContent = jsonEncode(data);
    return fileContent;
  }

  Future<void> save({void Function()? onComplete, bool changeModified = true, bool upload = true}) async {
    File file = File(path);
    if (!file.existsSync()) {
      originalCreated = DateTime.now();
      if (!editedCreated) {
        created = DateTime.now();
      }
    }
    if (changeModified) {
      if (!editedModified) {
        modified = DateTime.now();
      }
      originalModified = DateTime.now();
    }
    String fileContent = toFileContent();
    await file.writeAsString(fileContent);

    if (upload) {
      // appWebChannel.uploadFolder(folder: this, fileContent: fileContent);
    }
  }

  Future<void> delete({bool upload = true}) async {
    File file = File(path);
    await file.delete();
    // for (dynamic item in AppStorage.getNoteList(filename)) {
    //   if (item is Note) {
    //     await item.delete();
    //   } else if (item is Folder) {
    //     await item.delete();
    //   }
    // }
    if (upload) {
      // appWebChannel.deleteFolder(folder: this);
    }
  }
}
