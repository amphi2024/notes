import 'dart:convert';
import 'dart:io';

import 'package:amphi/models/app_theme_core.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/channels/app_web_delete.dart';
import 'package:notes/channels/app_web_upload.dart';
import 'package:notes/extensions/date_extension.dart';
import 'package:notes/methods/generated_file_name.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/item.dart';
import 'package:notes/models/note.dart';

class Folder extends Item {

  Folder({
    required super.title,
    required super.filename,
    required super.path,
    required super.location,
    required super.created,
    required super.originalCreated,
    required super.modified,
    required super.originalModified,
    super.deleted
});

  static Folder createdFolder(String location) {
    String filename = generatedFileName(
        "folder", appStorage.notesPath);
    return Folder(
        title: "",
        filename: filename,
        path: "${appStorage.notesPath}/$filename",
        location: location,
        created: DateTime.now(),
        originalCreated: DateTime.now(),
        modified: DateTime.now(),
        originalModified: DateTime.now());
  }

  static Folder fromFile(File file) {
    try {
      String fileContent = file.readAsStringSync();
      Map<String, dynamic> map = jsonDecode(fileContent);
      DateTime created = parsedDateTime(map["created"]);
      DateTime originalCreated = parsedDateTime(map["originalCreated"]);
      DateTime modified = parsedDateTime(map["modified"]);
      DateTime originalModified = parsedDateTime(map["originalModified"]);
      DateTime? deleted;
      if(map["deleted"] != null) {
        deleted = parsedDateTime(map["deleted"]);
      }
      Folder folder = Folder(
          filename: file.path.split("/").last,
          title: map["name"],
          location: map["location"] ?? "",
          path: file.path,
          created: created,
          modified: modified,
          originalCreated: originalCreated,
          originalModified: originalModified,
          deleted: deleted
      );
      return folder;
    }
    catch(e) {
      Folder folder = Folder(
          title: "unknown",
          filename: "",
          location: "",
          path: file.path,
          created: DateTime.now(),
          modified: DateTime.now(),
          originalCreated: DateTime.now(),
          originalModified: DateTime.now()
      );
      return folder;
    }
  }

  String toFileContent() {
    Map<String, dynamic> data = {
      "name": title,
      "location": location,
      "created": created.toDataString(),
      "modified": modified.toDataString(),
      "originalCreated": originalCreated.toDataString(),
      "originalModified": originalModified.toDataString(),
    };
    if(backgroundColor != null) {
      data.addAll(
          {"backgroundColor": backgroundColor!.toHex()}
      );
    }
    if(deleted != null) {
      data.addAll(
          {"deleted": deleted!.toDataString()}
      );
    }
    String fileContent = jsonEncode(data);
    return fileContent;
  }

  Future<void> save({void Function()? onComplete, bool changeModified = true, bool upload = true}) async {
    File file = File(path);
    if(!file.existsSync()) {
      originalCreated = DateTime.now();
      if(!editedCreated) {
        created = DateTime.now();
      }
    }
    if(changeModified) {
      if(!editedModified) {
        modified = DateTime.now();
      }
      originalModified = DateTime.now();
    }
   String fileContent = toFileContent();
    await file.writeAsString(fileContent);

    if(upload) {
      appWebChannel.uploadFolder(folder: this, fileContent: fileContent);
    }
  }

  Future<void> delete({bool upload = true}) async {
    File file = File(path);
    await file.delete();
    for(dynamic item in AppStorage.getNoteList(filename)) {
      if(item is Note) {
        await item.delete();
      }
      else if(item is Folder) {
        await item.delete();
      }
    }
    if(upload) {
      appWebChannel.deleteFolder(folder: this);
    }
  }
}