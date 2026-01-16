
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/database/database_helper.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/thumbnail_data.dart';
import '../models/app_cache_data.dart';
import '../models/note.dart';
import '../models/sort_option.dart';
import '../utils/notes_migration.dart';
import '../utils/orphan_notes.dart';
import '../utils/theme_migration.dart';

class NotesState {
  final Map<String, Note> notes;
  final Map<String, List<String>> idLists;

  NotesState(this.notes, this.idLists);

  List<String> get trash => idLists.putIfAbsent("!TRASH", () => []);

  List<String> idListByFolderId(String id, {String? searchKeyword}) {
    var list = idLists[id] ?? [];
    if(searchKeyword == null) {
      return list;
    }
    return list.where((id) => notes[id]?.title.toLowerCase().contains(searchKeyword.toLowerCase()) ?? false).toList();
  }

  List<String> idListByFolderIdNoteOnly(String id, {String? searchKeyword}) {
    return idListByFolderId(id, searchKeyword: searchKeyword).where((id) => notes[id]?.isFolder == false).toList();
  }

  List<String> idListByFolderIdFolderOnly(String id, {String? searchKeyword}) {
    return idListByFolderId(id, searchKeyword: searchKeyword).where((id) => notes[id]?.isFolder == true).toList();
  }
}

class NotesNotifier extends Notifier<NotesState> {
  @override
  NotesState build() {
    return NotesState({}, {});
  }

  static Future<NotesState> initialized() async {
    final database = await databaseHelper.database;
    final Map<String, Note> notes = {};
    final Map<String, List<String>> idLists = {
      "" : [],
      "!TRASH": []
    };
    final List<Map<String, dynamic>> list = await database.rawQuery("SELECT * FROM notes", []);
    final now = DateTime.now();
    for(var data in list) {
      final note = Note.fromMap(data);

      if(note.deleted == null) {
        notes[note.id] = note;
        idLists.putIfAbsent(note.parentId, () => []).add(note.id);
      }
      else {
        if(now.difference(note.deleted!).inDays > appSettings.permanentDeletionPeriod) {
          await note.delete();
        }
        else {
          notes[note.id] = note;
          idLists["!TRASH"]!.add(note.id);
        }
      }
    }

    idLists.forEach((folderId, list) {
      list.sortNotes(appCacheData.sortOption(folderId), notes);
    });

    await verifyNotesMigration(database);
    await verifyThemesMigration(database);

    checkOrphanNotes(database);

    final notesState = NotesState(notes, idLists);
    return notesState;
  }

  Future<void> rebuild() async {
    state = await initialized();
  }

  void insertNote(Note note) {
    final notes = {...state.notes, note.id: note};

    final list = state.idLists.putIfAbsent(note.parentId, () => []);
    final mergedList = list.contains(note.id) ? [...list] : [...list, note.id];

    final idLists = {...state.idLists, note.parentId: mergedList};
    idLists[note.parentId]!.sortNotes(appCacheData.sortOption(note.parentId), notes);
    state = NotesState(notes, idLists);
  }

  void updateNotePreview({required String noteId, required String title, required String subtitle, ThumbnailData? thumbnailData}) {
    final note = state.notes.get(noteId);
    if(title != note.title || subtitle != note.subtitle || thumbnailData != note.thumbnailData) {
      note.title = title;
      note.subtitle = subtitle;
      note.thumbnailData = thumbnailData;
      note.modified = DateTime.now();

      final list = state.idLists.putIfAbsent(note.parentId, () => []);
      list.sortNotes(appCacheData.sortOption(note.parentId), state.notes);

      final idLists = {...state.idLists, note.parentId: list};
      state = NotesState({...state.notes, noteId: note}, idLists);
    }
  }

  void moveNotes(List<String> selected, String from, String to) {
    final fromList = state.idLists.putIfAbsent(from, () => []).where((id) => !selected.contains(id)).toList();
    final toList = [...state.idLists.putIfAbsent(to, () => []), ...selected];

    final idLists = {...state.idLists, from: fromList, to: toList};
    final notes = {...state.notes};

    idLists[from]!.sortNotes(appCacheData.sortOption(from), notes);
    idLists[to]!.sortNotes(appCacheData.sortOption(to), notes);

    state = NotesState(notes, idLists);
  }

  void deleteNotes(List<String> list) {
    final notes = {...state.notes}..removeWhere((key, value) => list.contains(key));
    final trash = state.trash.where((id) => !list.contains(id)).toList();
    final idList = {...state.idLists, "!TRASH": trash};
    state = NotesState(notes, idList);
  }

  void clear() {
    state = NotesState({}, {});
  }

  void sortNotes(String? folderId) {
    final idList = state.idLists.putIfAbsent(folderId ?? "", () => []);

    idList.sortNotes(appCacheData.sortOption(folderId ?? "!HOME"), state.notes);

    final idLists = {...state.idLists, folderId ?? "": idList};

    state = NotesState({...state.notes}, idLists);
  }

  void applyServerUpdate(Note note) {
    final idLists = {...state.idLists};
    final oldNote = state.notes.get(note.id);

    final oldParentId = oldNote.deleted != null ? "!TRASH" : oldNote.parentId;
    final parentId = note.deleted != null ? "!TRASH" : note.parentId;

    if(oldParentId != parentId) {
      idLists[oldParentId]?.remove(note.id);
    }
    if(idLists[parentId]?.contains(note.id) != true) {
      idLists[parentId]?.add(note.id);
      idLists[parentId]?.sortNotes(appCacheData.sortOption(parentId), state.notes);
    }

    state = NotesState({...state.notes, note.id: note}, idLists);
  }

}

final notesProvider = NotifierProvider<NotesNotifier, NotesState>(NotesNotifier.new);


extension NoteNullSafeExtension on Map<String, Note> {
  Note get(String id) {
    return this[id] ?? Note(id: id);
  }
}

extension SortEx on List {

  void sortNotes(String sortOption, Map<String, Note> map) {
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
          return map.get(a).title.toLowerCase().compareTo(map.get(b).title.toLowerCase());
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