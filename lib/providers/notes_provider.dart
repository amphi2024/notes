import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_cache_data.dart';
import '../models/note.dart';
import '../models/sort_option.dart';

class NotesState {
  final Map<String, Note> notes;
  final Map<String, List<String>> idLists;
  final List<String> trash;

  NotesState(this.notes, this.idLists, this.trash);
}

class NotesNotifier extends Notifier<NotesState> {
  @override
  NotesState build() {
    return NotesState({}, {}, []);
  }

  void insertFile(Note note) {
    final files = {...state.notes, note.id: note};

    final list = state.idLists.putIfAbsent(note.parentId, () => []);
    final mergedList = list.contains(note.id) ? [...list] : [...list, note.id];

    final idLists = {...state.idLists, note.parentId: mergedList};
    final sortOptionId = note.parentId.isEmpty ? "!FILES" : note.parentId;
    idLists[note.parentId]!.sortFiles(appCacheData.sortOption(sortOptionId), files);
    state = NotesState(files, idLists, [...state.trash]);
  }

  void moveNotesToTrash(String folderId, List<String> list) {
    final idList = state.idLists.putIfAbsent(folderId, () => []).where((id) => !list.contains(id)).toList();
    final idLists = {...state.idLists, folderId: idList};
    final trash = [
      ...state.trash,
      ...list.where((id) => !state.trash.contains(id)),
    ];
    final files = {...state.notes};
    trash.sortFiles(appCacheData.sortOption("!TRASH"), files);
    state = NotesState(files, idLists, trash);
  }

  void moveNotes(List<String> selected, String from, String to) {
    final fromList = state.idLists.putIfAbsent(from, () => []).where((id) => !selected.contains(id)).toList();
    final toList = [...state.idLists.putIfAbsent(to, () => []), ...selected];

    final idLists = {...state.idLists, from: fromList, to: toList};
    final trash = [...state.trash];
    final files = {...state.notes};

    final sortOptionIdFrom = from.isEmpty ? "!FILES" : from;
    final sortOptionIdTo = to.isEmpty ? "!FILES" : to;

    idLists[from]!.sortFiles(appCacheData.sortOption(sortOptionIdFrom), files);
    idLists[sortOptionIdTo]!.sortFiles(appCacheData.sortOption(sortOptionIdFrom), files);

    state = NotesState(files, idLists, trash);
  }

  void restoreNotes(List<String> list) {

    final idLists = {...state.idLists};
    idLists[""]!.addAll(list);

    final trash = state.trash.where((id) => !list.contains(id)).toList();
    final files = {...state.notes};
    idLists[""]!.sortFiles(appCacheData.sortOption("!FILES"), files);
    state = NotesState(files, idLists, trash);
  }

  void deleteNotes(List<String> list) {
    final files = {...state.notes}..removeWhere((key, value) => list.contains(key));
    final idList = {...state.idLists};
    final trash = state.trash.where((id) => !list.contains(id)).toList();
    state = NotesState(files, idList, trash);
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

  void init() {

  }

  void refreshAllNotes() {

  }

  void syncDataFromEvents() {

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