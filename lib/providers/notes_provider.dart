import 'dart:convert';

import 'package:amphi/utils/path_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/utils/notes_migration.dart';
import 'package:notes/utils/theme_migration.dart';
import '../models/app_cache_data.dart';
import '../models/note.dart';
import '../models/sort_option.dart';
import 'package:sqflite/sqflite.dart';

class NotesState {
  final Map<String, Note> notes;
  final Map<String, List<String>> idLists;
  final List<String> trash;

  NotesState(this.notes, this.idLists, this.trash);

  List<String> idListByFolderId(String id) {
    return idLists[id] ?? [];
  }

  void loadChildren(String folderId) async {
    final database = await openDatabase(
      PathUtils.join(appStorage.selectedUser.storagePath, "notes.db"),
      version: 1,
    );

    for(var id in idLists[folderId] ?? []) {
      final List<Map<String, dynamic>> children = await database.rawQuery("SELECT * FROM notes WHERE parent_id == ?", [id]);
      for(var childData in children) {
        final child = Note.fromMap(childData);
        idLists.putIfAbsent(id, () => []).add(child.id);
        notes[child.id] = child;
      }
    }

    await database.close();
  }
}

class NotesNotifier extends Notifier<NotesState> {
  @override
  NotesState build() {
    return NotesState({}, {}, []);
  }

  void insertFile(Note note) {
    final notes = {...state.notes, note.id: note};

    final list = state.idLists.putIfAbsent(note.parentId, () => []);
    final mergedList = list.contains(note.id) ? [...list] : [...list, note.id];

    final idLists = {...state.idLists, note.parentId: mergedList};
    final sortOptionId = note.parentId.isEmpty ? "!HOME" : note.parentId;
    idLists[note.parentId]!.sortFiles(appCacheData.sortOption(sortOptionId), notes);
    state = NotesState(notes, idLists, [...state.trash]);
  }

  void moveNotesToTrash(String folderId, List<String> list) {
    final idList = state.idLists.putIfAbsent(folderId, () => []).where((id) => !list.contains(id)).toList();
    final idLists = {...state.idLists, folderId: idList};
    final trash = [
      ...state.trash,
      ...list.where((id) => !state.trash.contains(id)),
    ];
    final notes = {...state.notes};
    trash.sortFiles(appCacheData.sortOption("!TRASH"), notes);
    state = NotesState(notes, idLists, trash);
  }

  void moveNotes(List<String> selected, String from, String to) {
    final fromList = state.idLists.putIfAbsent(from, () => []).where((id) => !selected.contains(id)).toList();
    final toList = [...state.idLists.putIfAbsent(to, () => []), ...selected];

    final idLists = {...state.idLists, from: fromList, to: toList};
    final trash = [...state.trash];
    final notes = {...state.notes};

    final sortOptionIdFrom = from.isEmpty ? "!HOME" : from;
    final sortOptionIdTo = to.isEmpty ? "!HOME" : to;

    idLists[from]!.sortFiles(appCacheData.sortOption(sortOptionIdFrom), notes);
    idLists[sortOptionIdTo]!.sortFiles(appCacheData.sortOption(sortOptionIdFrom), notes);

    state = NotesState(notes, idLists, trash);
  }

  void restoreNotes(List<String> list) {

    final idLists = {...state.idLists};
    idLists[""]!.addAll(list);

    final trash = state.trash.where((id) => !list.contains(id)).toList();
    final notes = {...state.notes};
    idLists[""]!.sortFiles(appCacheData.sortOption("!HOME"), notes);
    state = NotesState(notes, idLists, trash);
  }

  void deleteNotes(List<String> list) {
    final notes = {...state.notes}..removeWhere((key, value) => list.contains(key));
    final idList = {...state.idLists};
    final trash = state.trash.where((id) => !list.contains(id)).toList();
    state = NotesState(notes, idList, trash);
  }

  void clear() {
    state = NotesState({}, {}, []);
  }

  void sortNotes(String? folderId) {
    final idList = state.idLists.putIfAbsent(folderId ?? "", () => []);
    idList.sortFiles(appCacheData.sortOption(folderId ?? "!HOME"), state.notes);

    final idLists = {...state.idLists, folderId ?? "": idList};

    state = NotesState({...state.notes}, idLists, [...state.trash]);
  }

  void sortTrash() {
    final trash = [...state.trash];
    trash.sortFiles(appCacheData.sortOption("!TRASH"), state.notes);
    state = NotesState({...state.notes}, {...state.idLists}, trash);
  }

  void init() async {
    final database = await openDatabase(
      PathUtils.join(appStorage.selectedUser.storagePath, "notes.db"),
        version: 1,
        onCreate: (Database db, int version) async {

          await db.execute("""
           CREATE TABLE IF NOT EXISTS notes (
            id TEXT PRIMARY KEY NOT NULL, 
            content TEXT, 
            created INTEGER NOT NULL,
            modified INTEGER NOT NULL,
            deleted INTEGER,
            is_folder BOOLEAN,
            parent_id TEXT,
            line_height INTEGER,
            text_size INTEGER,
            text_color INTEGER,
            background_color INTEGER,
            background TEXT,
            title TEXT,
            subtitle TEXT
          );""");

          await db.execute("""
           CREATE TABLE IF NOT EXISTS themes (
            id TEXT PRIMARY KEY NOT NULL,
            title TEXT NOT NULL,
            created INTEGER NOT NULL,
            modified INTEGER NOT NULL,

            background_light INTEGER NOT NULL,
            text_light INTEGER NOT NULL,
            accent_light INTEGER NOT NULL,
            card_light INTEGER NOT NULL,
            floating_button_background_light INTEGER NOT NULL,
            floating_button_icon_light INTEGER NOT NULL,

            background_dark INTEGER NOT NULL,
            text_dark INTEGER NOT NULL,
            accent_dark INTEGER NOT NULL,
            card_dark INTEGER NOT NULL,
            floating_button_background_dark INTEGER NOT NULL,
            floating_button_icon_dark INTEGER NOT NULL
          );""");
          await migrateNotes(db);
          await migrateThemes(db);
        }
    );

    final Map<String, Note> notes = {};
    final Map<String, List<String>> idLists = {
      "" : []
    };
    final List<String> trash = [];
    final List<Map<String, dynamic>> list = await database.rawQuery("SELECT * FROM notes WHERE parent_id IS NULL", []);
    for(var data in list) {
      final note = Note.fromMap(data);

      notes[note.id] = note;
      idLists[""]!.add(note.id);
    }

    await database.close();

    state = NotesState(notes, idLists, trash);
    state.loadChildren("");
  }

}

final notesProvider = NotifierProvider<NotesNotifier, NotesState>(NotesNotifier.new);


extension NoteNullSafeExtension on Map<String, Note> {
  Note get(String id) {
    return this[id] ?? Note(id: id);
  }
}

extension SortEx on List {
  void sortFiles(String sortOption, Map<String, Note> map) {
    switch(sortOption) {
      case SortOption.created:
        sort((a, b) {
          return map.get(a).created.compareTo(map.get(b).created);
        });
        break;
      case SortOption.modified:
        sort((a, b) {
          return map.get(a).modified.compareTo(map.get(b).modified);
        });
        break;
      case SortOption.deleted:
        sort((a, b) {
          return map.get(a).deleted!.compareTo(map.get(b).deleted!);
        });
        break;
      case SortOption.createdDescending:
        sort((a, b) {
          return map.get(b).created.compareTo(map.get(a).created);
        });
        break;
      case SortOption.modifiedDescending:
        sort((a, b) {
          return map.get(b).modified.compareTo(map.get(a).modified);
        });
        break;
      case SortOption.deletedDescending:
        sort((a, b) {
          return map.get(b).deleted!.compareTo(map.get(a).deleted!);
        });
        break;
      case SortOption.title:
        sort((a, b) {
          return map.get(b).title.toLowerCase().compareTo(map.get(a).title.toLowerCase());
        });
        break;
      case SortOption.titleDescending:
        sort((a, b) {
          return map.get(b).title.compareTo(map.get(a).title);
        });
        break;
    }
  }
}