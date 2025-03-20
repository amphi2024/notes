import 'dart:ui';

import 'package:amphi/utils/random_string.dart';
import 'package:notes/components/note_editor/embed_block/table/table/table_data.dart';
import 'package:notes/components/note_editor/embed_block/view_pager/view_pager_data.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/file_in_note.dart';
import 'package:notes/models/note.dart';

final noteEmbedBlocks = NoteEmbedBlocks.getInstance();

class NoteEmbedBlocks {
  static final NoteEmbedBlocks _instance = NoteEmbedBlocks._internal();
  NoteEmbedBlocks._internal();

  static NoteEmbedBlocks getInstance() => _instance;

  Map<String, TableData> tables = {};
  Map<String, NoteEditingController> subNotes = {};
  Map<String, Color> dividers = {};
  Map<String, ViewPagerData> viewPagers = {};
  Map<String, FileInNote> files = {};

  String generatedTableKey() => generatedKey(tables);
  String generatedSubNoteKey() => generatedKey(subNotes);
  String generatedDividerKey() => generatedKey(dividers);
  String generatedViewPagerKey() => generatedKey(viewPagers);
  String generatedFileKey() => generatedKey(files);

  NoteEditingController getSubNote(String key) {
    if(subNotes[key] != null) {
      return subNotes[key]!;
    }
    else {
      subNotes[key] = NoteEditingController(note: Note.subNote(appState.noteEditingController.note) );
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

  ViewPagerData getViewPager(String key) {
    if(viewPagers[key] != null) {
      return viewPagers[key]!;
    }
    else {
      viewPagers[key ] = ViewPagerData(appState.noteEditingController.note);
      return viewPagers[key]!;
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
    viewPagers.clear();
    tables.clear();
    subNotes.clear();
    dividers.clear();
    files.clear();
  }

}