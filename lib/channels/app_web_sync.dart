import 'dart:convert';
import 'dart:io';

import 'package:amphi/models/update_event.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/channels/app_web_download.dart';
import 'package:notes/channels/app_web_upload.dart';
import 'package:notes/methods/get_themes.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/app_theme.dart';
import 'package:notes/models/folder.dart';
import 'package:notes/models/note.dart';

extension AppWebSync on AppWebChannel {
  void syncMissingFiles() async {
    getThemes(onSuccess: (list) {
      List<AppTheme> appThemeList = allThemes();

      for (int i = 0; i < appThemeList.length; i++) {
        // remove items that existing on server
        for (int j = 0; j < list.length; j++) {
          Map<String, dynamic> map = list[j];
          if (map["filename"] == appThemeList[i].filename) {
            appThemeList.removeAt(i);
            i--;
            break;
          }
        }
      }

      for (AppTheme appTheme in appThemeList) {
        // upload themes that not exist
        uploadTheme(themeFileContent: jsonEncode(appTheme.toMap()), themeFilename: appTheme.filename);
      }

      for (int i = 0; i < list.length; i++) {
        Map<String, dynamic> map = list[i];
        String filename = map["filename"];
        DateTime modified = DateTime.fromMillisecondsSinceEpoch(map["modified"]).toLocal();
        File file = File(PathUtils.join(appStorage.themesPath, filename));
        if (!file.existsSync()) {
          downloadTheme(filename: filename);
        } else if (modified.isAfter(file.lastModifiedSync())) {
          downloadTheme(filename: filename);
        }
      }
    });

    getNotes(onSuccess: (list) async {
      List<dynamic> noteList = AppStorage.getAllNotes();

      for (int i = 0; i < noteList.length; i++) {
        // remove items that existing on server
        dynamic item = noteList[i];
        for (int j = 0; j < list.length; j++) {
          Map<String, dynamic> map = list[j];
          if (item is Note && map["filename"] == item.filename) {
            noteList.removeAt(i);
            i--;
            break;
          } else if (item is Folder && item.filename == map["filename"]) {
            noteList.removeAt(i);
            i--;
            break;
          }
        }
      }

      for (dynamic item in noteList) {
        // upload all items that not existing on server
        if (item is Note) {
          uploadNote(note: item, fileContent: item.toFileContent());
        } else if (item is Folder) {
          uploadFolder(folder: item, fileContent: item.toFileContent());
        }
      }

      for (int i = 0; i < list.length; i++) {
        // download items that not exist or older modified
        Map<String, dynamic> map = list[i];
        String filename = map["filename"];
        DateTime modified = DateTime.fromMillisecondsSinceEpoch(map["modified"]).toLocal();
        File file = File(PathUtils.join(appStorage.notesPath, filename));
        if (!file.existsSync() || (file.existsSync() && modified.isAfter(file.lastModifiedSync()))) {
          if (filename.endsWith(".note")) {
            appWebChannel.downloadNote(
                filename: filename,
                onSuccess: (note) {
                  AppStorage.getNoteList(note.location).add(note);
                  if (i == list.length - 1) {
                    appState.notifySomethingChanged(() {
                      appStorage.initNotes();
                    });
                  }
                });
          } else if (filename.endsWith(".folder")) {
            appWebChannel.downloadFolder(
                filename: filename,
                onSuccess: (folder) {
                  AppStorage.getNoteList(folder.location).add(folder);
                  if (i == list.length - 1) {
                    appState.notifySomethingChanged(() {
                      appStorage.initNotes();
                    });
                  }
                });
          }
        }
      }
    });
  }

  void _downloadNoteOrFolder(UpdateEvent updateEvent) {
    if (updateEvent.value.endsWith(".note")) {
      appWebChannel.downloadNote(
          filename: updateEvent.value,
          onSuccess: (item) {
            appState.notifySomethingChanged(() {
              AppStorage.notifyNote(item);
            });
          });
    } else if (updateEvent.value.endsWith(".folder")) {
      appWebChannel.downloadFolder(
          filename: updateEvent.value,
          onSuccess: (item) {
            appState.notifySomethingChanged(() {
              AppStorage.notifyFolder(item);
            });
          });
    }
  }

  Future<void> syncDataFromEvents() async {
    if (appStorage.selectedUser.token.isNotEmpty) {
      appWebChannel.getEvents(onResponse: (updateEvents) async {
        for (UpdateEvent updateEvent in updateEvents) {
          switch (updateEvent.action) {
            case UpdateEvent.renameUser:
              appStorage.selectedUser.name = updateEvent.value;
              appStorage.saveSelectedUserInformation(updateEvent: updateEvent);
              break;
            case UpdateEvent.uploadNote:
              File file = File(PathUtils.join(appStorage.notesPath, updateEvent.value));
              if (!file.existsSync()) {
                _downloadNoteOrFolder(updateEvent);
              } else if (updateEvent.date.isAfter(file.lastModifiedSync())) {
                _downloadNoteOrFolder(updateEvent);
              }
              break;
            case UpdateEvent.uploadTheme:
              File file = File(PathUtils.join(appStorage.themesPath, updateEvent.value));
              if (!file.existsSync()) {
                appWebChannel.downloadTheme(filename: updateEvent.value);
              } else if (updateEvent.date.isAfter(file.lastModifiedSync())) {
                appWebChannel.downloadTheme(filename: updateEvent.value);
              }
              break;
            case UpdateEvent.deleteNote:
              for (dynamic item in AppStorage.trashes()) {
                if (item is Note && item.filename == updateEvent.value) {
                  item.delete(upload: false);
                  AppStorage.trashes().remove(item);
                  break;
                } else if (item is Folder && item.filename == updateEvent.value) {
                  item.delete(upload: false);
                  AppStorage.trashes().remove(item);
                  break;
                }
              }
              break;
            case UpdateEvent.deleteTheme:
              File file = File(PathUtils.join(appStorage.themesPath, updateEvent.value));
              file.delete();
              break;
          }
          appWebChannel.acknowledgeEvent(updateEvent);
        }
      });
    }
  }
}
