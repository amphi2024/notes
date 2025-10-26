import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/database/database_helper.dart';
import '../models/app_cache_data.dart';
import '../models/note.dart';
import '../models/sort_option.dart';

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

  Future<void> preloadNotes(String folderId) async {
    final database = await databaseHelper.database;

    for(var id in idLists[folderId] ?? []) {
      final List<Map<String, dynamic>> children = await database.rawQuery("SELECT * FROM notes WHERE parent_id == ?", [id]);
      for(var childData in children) {
        final child = Note.fromMap(childData);
        idLists.putIfAbsent(id, () => []).add(child.id);
        notes[child.id] = child;
      }
    }

  }

  void releaseNotes(String folderId) {
    for(var id in idLists[folderId] ?? []) {
      for(var child in idLists[id] ?? []) {
        notes.remove(child);
      }
      idLists.remove(id);
    }
  }
}

class NotesNotifier extends Notifier<NotesState> {
  @override
  NotesState build() {
    return NotesState({}, {});
  }

  void insertNote(Note note) {
    final notes = {...state.notes, note.id: note};

    final list = state.idLists.putIfAbsent(note.parentId, () => []);
    final mergedList = list.contains(note.id) ? [...list] : [...list, note.id];

    final idLists = {...state.idLists, note.parentId: mergedList};
    idLists[note.parentId]!.sortNotes(appCacheData.sortOption(note.parentId), notes);
    state = NotesState(notes, idLists);
  }

  void updateNotePreview({required String noteId, required String title, required String subtitle, String? thumbnailImageFilename}) {
    final note = state.notes.get(noteId);
    if(title != note.title || subtitle != note.subtitle || thumbnailImageFilename != note.thumbnailImageFilename) {
      note.title = title;
      note.subtitle = subtitle;
      note.thumbnailImageFilename = thumbnailImageFilename;
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

  void restoreNotes(List<String> list) {

    final idLists = {...state.idLists};
    idLists[""]!.addAll(list);

    final trash = state.trash.where((id) => !list.contains(id)).toList();
    final notes = {...state.notes};
    idLists[""]!.sortNotes(appCacheData.sortOption("!HOME"), notes);
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

  void init() async {
    final database = await databaseHelper.database;
    final Map<String, Note> notes = {};
    final Map<String, List<String>> idLists = {
      "" : []
    };
    final List<Map<String, dynamic>> list = await database.rawQuery("SELECT * FROM notes WHERE parent_id IS NULL", []);
    for(var data in list) {
      final note = Note.fromMap(data);

      notes[note.id] = note;
      idLists[""]!.add(note.id);
    }

    idLists[""]!.sortNotes(appCacheData.sortOption("!HOME"), notes);

    final newState = NotesState(notes, idLists);
    await newState.preloadNotes("");
    state = newState;
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