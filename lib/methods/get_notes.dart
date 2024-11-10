import 'dart:io';

import 'package:notes/models/app_storage.dart';
import 'package:notes/models/folder.dart';
import 'package:notes/models/note.dart';

List<dynamic> getAllNotes() {
  List<dynamic> notes = [];

  Directory directory = Directory(appStorage.notesPath);

  List<FileSystemEntity> fileList = directory.listSync();

  for (FileSystemEntity file in fileList) {
    if (file is File) {
      //notes.add(Note.fromFile(file));
      if(file.path.endsWith(".note")) {
        notes.add(Note.fromFile(file));
      }
      else if(file.path.endsWith(".folder")) {
        notes.add(Folder.fromFile(file));

      }
    }
  }

  return notes;
}

List<dynamic> getNotes({required List<dynamic> noteList, required String home}) {
  List<dynamic> list = [];
  for(dynamic item in noteList) {
    if(item.location == home) {
        list.add(item);
    }
  }
  return list;
}