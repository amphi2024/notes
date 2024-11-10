import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/channels/app_web_download.dart';
import 'package:notes/extensions/date_extension.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/app_storage.dart';
import 'package:amphi/models/update_event.dart';
import 'package:notes/models/folder.dart';
import 'package:notes/models/note.dart';

extension AppWebSync on AppWebChannel {

  void downloadMissingFiles(BuildContext context) async {
    // getFiles(path: "themes", onSuccess: (list) {
    //   for (int i = 0; i < list.length; i++) {
    //     Map<String, dynamic> map = list[i];
    //     String filename = map["filename"];
    //     String modifiedString = map["modified"];
    //     DateTime modified = parsedDateTime(modifiedString);
    //     File file = File("${appStorage.selectedUser.storagePath}/themes/$filename");
    //     if (!file.existsSync()) {
    //       downloadTheme(filename: filename);
    //     }
    //     else if(modified.isAfter(file.lastModifiedSync())){
    //       downloadTheme(filename: filename);
    //     }
    //   }
    // });

  //  getImages(noteFilename: noteFilename)
  //   getFiles(path: "notes/images", onSuccess: (list) {
  //     for (int i = 0; i < list.length; i++) {
  //       Map<String, dynamic> map = list[i];
  //       String filename = map["filename"];
  //       File file = File("${appStorage.imagesPath}/$filename");
  //       if (!file.existsSync()) {
  //         downloadImage(filename: filename);
  //       }
  //     }
  //   });

    // getFiles(path: "notes/videos", onSuccess: (list) {
    //   for (int i = 0; i < list.length; i++) {
    //     Map<String, dynamic> map = list[i];
    //     String filename = map["filename"];
    //     File file = File("${appStorage.videosPath}/$filename");
    //     if (!file.existsSync()) {
    //       downloadVideo(filename: filename);
    //     }
    //   }
    // });

    getFiles(path: "notes",
        onSuccess: (list) async {
          for (int i = 0; i < list.length; i++) {
            Map<String, dynamic> map = list[i];
            String filename = map["filename"];
            String modifiedString = map["modified"];
            DateTime modified = parsedDateTime(modifiedString);
            File file = File("${appStorage.notesPath}/$filename");
            if (!file.existsSync() || (file.existsSync() && modified.isAfter(file.lastModifiedSync()) )   ) {
              if (filename.endsWith(".note")) {
                appWebChannel.downloadNote(filename: filename, onSuccess: (note) {
                  AppStorage.getNoteList(note.location).add(note);
                  if(i == list.length - 1) {
                    appState.notifySomethingChanged(() {
                      appStorage.initNotes();
                    });
                  }
                });
              }
              else if(filename.endsWith(".folder")) {
                appWebChannel.downloadFolder(filename: filename, onSuccess: (folder) {
                  AppStorage.getNoteList(folder.location).add(folder);
                  if(i == list.length - 1) {
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

  Future<void> syncDataFromEvents() async {
    if(appStorage.selectedUser.token.isNotEmpty) {

      appWebChannel.getEvents(onResponse: (updateEvents) async {
        for(UpdateEvent updateEvent in updateEvents) {
        switch (updateEvent.action) {
          case UpdateEvent.renameUser:
            appStorage.selectedUser.name = updateEvent.value;
            appStorage.saveSelectedUserInformation(updateEvent: updateEvent);
            break;
          case UpdateEvent.uploadNote:
            if(updateEvent.value.endsWith(".note")) {
              appWebChannel.downloadNote(
                  filename: updateEvent.value,
                  onSuccess: (item) {
                    appState.notifySomethingChanged(() {
                      AppStorage.notifyNote(item);
                    });
                  });
            }
            else if(updateEvent.value.endsWith(".folder")) {
              appWebChannel.downloadFolder(
                  filename: updateEvent.value,
                  onSuccess: (item) {
                    appState.notifySomethingChanged(() {
                      AppStorage.notifyFolder(item);
                    });
                  });
            }
            break;
          // case UpdateEvent.uploadImage:
          //   appWebChannel.downloadImage(filename: updateEvent.value);
          //   break;
          // case UpdateEvent.uploadVideo:
          //   appWebChannel.downloadVideo(filename: updateEvent.value);
          //   break;
          case UpdateEvent.uploadTheme:
            appWebChannel.downloadTheme(filename: updateEvent.value);
            break;
          case UpdateEvent.deleteNote:
            for(dynamic item in AppStorage.trashes()) {
              if(item is Note && item.filename == updateEvent.value) {
                item.delete(upload: false);
                AppStorage.trashes().remove(item);
                break;
              }
              else if(item is Folder && item.filename == updateEvent.value) {
                item.delete(upload: false);
                AppStorage.trashes().remove(item);
                break;
              }
            }
            break;
          // case UpdateEvent.deleteImage:
          //   File file = File("${appStorage.imagesPath}/${updateEvent.value}");
          //   file.delete();
          //   break;
          // case UpdateEvent.deleteVideo:
          //   File file = File("${appStorage.videosPath}/${updateEvent.value}");
          //   file.delete();
          //   break;
          case UpdateEvent.deleteTheme:
            File file = File("${appStorage.selectedUser.storagePath}/themes/${updateEvent.value}");
            file.delete();
            break;
        }
        appWebChannel.acknowledgeEvent(updateEvent);
        }

      });
    }
  }
}