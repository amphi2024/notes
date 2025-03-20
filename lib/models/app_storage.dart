import 'dart:io';

import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/models/app_storage_core.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/channels/app_web_download.dart';
import 'package:notes/extensions/sort_extension.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/folder.dart';
import 'package:notes/models/note.dart';

final appStorage = AppStorage.getInstance();

class AppStorage extends AppStorageCore {
  static final AppStorage _instance = AppStorage._internal();

  AppStorage._internal();

  static AppStorage getInstance() => _instance;

  late String notesPath;
  late String themesPath;

  Map<String, List<dynamic>> notes = {};
  List<dynamic>? selectedNotes;

  static List<dynamic> trashes() {
    return getNoteList("!Trashes");
  }

  static List<dynamic> getNoteList(String location) {
    List<dynamic>? list = getInstance().notes[location];
    if (list != null) {
      return list;
    } else {
      List<dynamic> allNotes = getAllNotes();
      getInstance().notes[location] = getNotes(noteList: allNotes, home: location);
      return getNotes(noteList: allNotes, home: location);
    }
  }

  static void moveSelectedNotesToTrash(String location) {
    for (dynamic item in appStorage.selectedNotes!) {
      if (item is Note) {
        item.location = "!Trashes";
        item.deleted = DateTime.now();
        item.save(changeModified: false);
        AppStorage.getNoteList(location).remove(item);
        AppStorage.trashes().add(item);
      } else if (item is Folder) {
        item.location = "!Trashes";
        item.deleted = DateTime.now();
        item.save(changeModified: false);
        AppStorage.getNoteList(location).remove(item);
        AppStorage.trashes().add(item);
      }
    }
    appStorage.selectedNotes = null;
  }

  static void refreshNoteList(void Function(List<dynamic>) onFinished) async {
    appWebChannel.getNotes(onSuccess: (list) {
      for (int i = 0; i < list.length; i++) {
        Map<String, dynamic> map = list[i];
        String filename = map["filename"];
        DateTime modified = DateTime.fromMillisecondsSinceEpoch(map["modified"]).toLocal();
        File file = File(PathUtils.join(appStorage.notesPath, filename));


        if (filename.endsWith(".note")) {
          if (!file.existsSync() || (file.existsSync() && modified.isAfter(file.lastModifiedSync()))) {
            appWebChannel.downloadNote(
                filename: filename,
                onSuccess: (note) {
                  AppStorage.getNoteList(note.location).add(note);
                });
          }
        } else if (filename.endsWith(".folder")) {
          if (!file.existsSync() || (file.existsSync() && modified.isAfter(file.lastModifiedSync()))) {
            appWebChannel.downloadFolder(
                filename: filename,
                onSuccess: (folder) {
                  AppStorage.getNoteList(folder.location).add(folder);
                });
          }
        }
      }
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    List<dynamic> allNotes = getAllNotes();
    onFinished(allNotes);
  }

  static void restoreSelectedNotes() async {
    for (dynamic item in appStorage.selectedNotes!) {
      if (item is Note) {
        item.location = "";
        item.deleted = null;
        await item.save(changeModified: false);
        AppStorage.getNoteList("").add(item);
        AppStorage.trashes().remove(item);
      } else if (item is Folder) {
        item.location = "";
        item.deleted = null;
        await item.save(changeModified: false);
        AppStorage.getNoteList("").add(item);
        AppStorage.trashes().remove(item);
      }
    }
    appState.notifySomethingChanged(() {
      appStorage.selectedNotes = null;
      AppStorage.getNoteList("").sortByOption();
    });
  }

  static void replaceNote(Note note) {
    getInstance().notes.update(note.location, (list) {
      for (int i = 0; i < list.length; i++) {
        dynamic item = list[i];
        if (list[i] is Note && item.filename == note.filename) {
          list[i] = note;
          break;
        }
      }
      return list;
    });
    // for(dynamic originalNote in getNoteList(note.home)) {
    //   if(originalNote is Note && originalNote.filename == note.filename) {
    //     originalNote = note;
    //   }
    // }
  }

  static void deleteSelectedNotes() async {
    for (dynamic item in appStorage.selectedNotes!) {
      if (item is Note) {
        await item.delete();
        AppStorage.trashes().remove(item);
      } else if (item is Folder) {
        await item.delete();
        AppStorage.trashes().remove(item);
      }
    }
    appState.notifySomethingChanged(() {
      appStorage.selectedNotes = null;
    });
  }

  static void notifyFolder(Folder folder) {
    getInstance().notes.updateAll((home, list) {
      bool notFound = true;
      for (int i = 0; i < list.length; i++) {
        dynamic originalItem = list[i];
        if (originalItem is Folder) {
          if (originalItem.filename == folder.filename) {
            notFound = false;
            if (originalItem.location == folder.location && folder.originalModified.isAfter(originalItem.originalModified)) {
              list[i] = folder;
            } else if (home != folder.location) {
              list.removeAt(i);
              i--;
            }
            break;
          }
        }
      }
      if (notFound && home == folder.location) {
        list.add(folder);
      }
      list.sortByOption();

      return list;
    });
  }

  static void notifyNote(Note note) {
    getInstance().notes.updateAll((home, list) {
      bool notFound = true;
      for (int i = 0; i < list.length; i++) {
        dynamic originalItem = list[i];
        if (originalItem is Note) {
          if (originalItem.filename == note.filename) {
            notFound = false;
            if (originalItem.location == note.location && note.originalModified.isAfter(originalItem.originalModified)) {
              list[i] = note;
            } else if (home != note.location) {
              list.removeAt(i);
              i--;
            }
            break;
          }
        }
      }
      if (notFound && home == note.location) {
        list.add(note);
      }
      list.sortByOption();

      return list;
    });
  }

  static void deleteObsoleteNotes() {
    DateTime currentDate = DateTime.now();
    DateTime dateBeforeDays = currentDate.subtract(Duration(days: 30));
    for (dynamic item in trashes()) {
      if (item is Note) {
        if (item.deleted != null) {
          if (item.deleted!.isBefore(dateBeforeDays)) {
            item.delete();
          }
        } else {
          item.location = "";
          item.save(changeModified: false);
        }
      } else if (item is Folder) {
        if (item.deleted != null) {
          if (item.deleted!.isBefore(dateBeforeDays)) {
            item.delete();
          }
        } else {
          item.location = "";
          item.save(changeModified: false);
        }
      }
    }
  }

  @override
  void initPaths() {
    super.initPaths();
    notesPath = "${selectedUser.storagePath}/notes";
    themesPath = "${selectedUser.storagePath}/themes";

    createDirectoryIfNotExists(notesPath);
    createDirectoryIfNotExists(themesPath);
  }

  void initNotes() {
    notes = {};
    List<dynamic> allNotes = getAllNotes();

    for (dynamic item in allNotes) {
      if (item is Folder) {
        notes[item.filename] = getNotes(noteList: allNotes, home: item.filename);
        notes[item.filename]!.sortByOption();
      }
      else if (item is Note) {
        item.deleteObsoleteMediaFiles();
      }
    }

    for (var item in allNotes) {
      if (item is Folder) {
        item.bringToFrontIfOrphan();
      }
      if (item is Note) {
        item.bringToFrontIfOrphan();
      }
    }

    notes[""] = getNotes(noteList: allNotes, home: "");
    notes[""]!.sortByOption();
    notes["!Trashes"] = getNotes(noteList: allNotes, home: "!Trashes");
    notes["!Trashes"]!.sortByOption();
  }

  static List<dynamic> getAllNotes() {
    List<dynamic> notes = [];

    Directory directory = Directory(appStorage.notesPath);

    List<FileSystemEntity> fileList = directory.listSync();

    for (int i = 0; i < fileList.length; i++) {
      FileSystemEntity file = fileList[i];
      if (file is File) {
        if (file.path.endsWith(".note")) {
          notes.add(Note.fromFile(file));
        } else if (file.path.endsWith(".folder")) {
          notes.add(Folder.fromFile(file));
        }
      }
      else if (file is Directory) {
        var dirName = PathUtils.basename(file.path);
        var noteFile = File(PathUtils.join(appStorage.notesPath, "${dirName}.note"));
        var draftFile = File(PathUtils.join(file.path, "draft.note"));
        if (!noteFile.existsSync()) {
          if (draftFile.existsSync()) {
            var draftNote = Note.fromFile(draftFile);
            var note = Note(filename: "${dirName}.note",
                path: noteFile.path,
                location: "",
                contents: draftNote.contents,
                created: DateTime.now(),
                originalCreated: DateTime.now(),
                modified: DateTime.now(),
                originalModified: DateTime.now());
            note.initTitles();
            notes.add(note);
          }
          else {
            file.delete(recursive: true);
          }
        }
      }
    }
    return notes;
  }

  static List<dynamic> getNotes({required List<dynamic> noteList, required String home}) {
    List<dynamic> list = [];
    for (dynamic item in noteList) {
      if (item.location == home) {
        list.add(item);
      }
    }
    return list;
  }
}
