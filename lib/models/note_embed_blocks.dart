import 'dart:ui';

import 'package:amphi/utils/random_string.dart';
import 'package:notes/components/note_editor/embed_block/table/table/table_data.dart';
import 'package:notes/components/note_editor/embed_block/view_pager/view_pager_data.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
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

  String generatedTableKey() => generatedKey(tables);
  String generatedSubNoteKey() => generatedKey(subNotes);
  String generatedDividerKey() => generatedKey(dividers);
  String generatedViewPagerKey() => generatedKey(viewPagers);

  NoteEditingController getSubNote(String key) {
    if(subNotes[key] != null) {
      return subNotes[key]!;
    }
    else {
      subNotes[key] = NoteEditingController(note: Note.subNote() );
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
      viewPagers[key ] = ViewPagerData();
      return viewPagers[key]!;
    }
  }

  String generatedKey(Map map) {
    String key = randomString(9);
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
  }

}