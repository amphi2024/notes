import 'dart:ui';

import 'package:amphi/utils/random_string.dart';
import 'package:notes/models/table_data.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:notes/models/file_in_note.dart';
import 'package:notes/models/note.dart';

final noteEmbedBlocks = NoteEmbedBlocks.getInstance();

class NoteEmbedBlocks {
  static final NoteEmbedBlocks _instance = NoteEmbedBlocks._internal();
  NoteEmbedBlocks._internal();

  static NoteEmbedBlocks getInstance() => _instance;

  Map<String, TableData> tables = {};
  Map<String, QuillController> subNotes = {};
  Map<String, Color> dividers = {};
  Map<String, FileInNote> files = {};

  String generatedTableKey() => generatedKey(tables);
  String generatedSubNoteKey() => generatedKey(subNotes);
  String generatedDividerKey() => generatedKey(dividers);
  String generatedFileKey() => generatedKey(files);

  QuillController getSubNote(String key) {
    if(subNotes[key] != null) {
      return subNotes[key]!;
    }
    else {
      // subNotes[key] = NoteEditingController(note: Note.subNote(appState.noteEditingController.note) );
      return subNotes[key]!;
    }
  }

  TableData getTable(String key) {
    if(tables[key] != null) {
      return tables[key]!;
    }
    else {
      tables[key ] = TableData();
      return tables[key]!;
    }
  }
  
  FileInNote getFile(String key) => files.putIfAbsent(key, () => FileInNote(filename: "not found", label: "not found"));

  String generatedKey(Map map) {
    String key = randomString(9, 3);
    if(map.containsKey(key)) {
      return generatedKey(map);
    }
    else {
      return key;
    }
  }

  void clear() {
    tables.clear();
    subNotes.clear();
    dividers.clear();
    files.clear();
  }

}