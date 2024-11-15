import 'package:http/http.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/app_theme.dart';
import 'package:notes/models/content.dart';
import 'package:notes/models/folder.dart';
import 'package:notes/models/note.dart';
import 'package:amphi/models/update_event.dart';

extension AppWebDelete on AppWebChannel {

  void deleteFolder({required Folder folder, void Function(int?)? onFailed , void Function()? onSuccess, bool postWebSocket = true}) async {
    try {
      final response = await delete(
        Uri.parse("${appSettings.serverAddress}/notes/${folder.filename}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": appStorage.selectedUser.token
        },
      );

      if (response.statusCode == 200) {
        if(onSuccess != null) {
          onSuccess();
        }
        if(postWebSocket) {
          UpdateEvent updateEvent = UpdateEvent(action: UpdateEvent.deleteNote, value: folder.filename, date: DateTime.now());
          postWebSocketMessage(updateEvent.toJson());
        }

      } else {
        if(onFailed != null) {
          onFailed(response.statusCode);
        }
      }
    }
    catch(e) {
      if(onFailed != null) {
        onFailed(null);
      }
    }
  }

  void deleteNote({required Note note, void Function(int?)? onFailed , void Function()? onSuccess, bool postWebSocket = true}) async {
    try {
      final response = await delete(
        Uri.parse("${appSettings.serverAddress}/notes/${note.filename}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": appStorage.selectedUser.token
        },
      );

      if (response.statusCode == 200) {
        if(onSuccess != null) {
          onSuccess();
        }
        if(postWebSocket) {
          UpdateEvent updateEvent = UpdateEvent(action: UpdateEvent.deleteNote, value: note.filename, date: DateTime.now());
          postWebSocketMessage(updateEvent.toJson());
        }

      } else {
        if(onFailed != null) {
          onFailed(response.statusCode);
        }
      }
    }
    catch(e) {
      if(onFailed != null) {
        onFailed(null);
      }
    }

    String noteFileNameOnly = note.filename.split(".").first;
    for(Content content in note.contents) {
      if (content.type == "img") {
        deleteImage(noteFileNameOnly: noteFileNameOnly, imageFilename: content.value, onFailed: onFailed, onSuccess:  onSuccess);
      }
      else if (content.type == "video") {
        deleteVideo(noteFileNameOnly: noteFileNameOnly, videoFilename: content.value);
      }
    }
  }

  void deleteImage({required String noteFileNameOnly, required String imageFilename ,void Function(int?)? onFailed , void Function()? onSuccess}) async {
    try {
      final response = await delete(
        Uri.parse("${appSettings.serverAddress}/notes/${noteFileNameOnly}/images/${imageFilename}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": appStorage.selectedUser.token
        },
      );

      if (response.statusCode == 200) {
        if(onSuccess != null) {
          onSuccess();
        }
      } else {
        if(onFailed != null) {
          onFailed(response.statusCode);
        }
      }
    }
    catch(e) {
      if(onFailed != null) {
        onFailed(null);
      }
    }

  }

  void deleteVideo({required String noteFileNameOnly, required String videoFilename , void Function(int?)? onFailed , void Function()? onSuccess}) async {
    try {
      final response = await delete(
        Uri.parse("${appSettings.serverAddress}/notes/${noteFileNameOnly}/videos/${videoFilename}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": appStorage.selectedUser.token
        },
      );

      if (response.statusCode == 200) {
        if(onSuccess != null) {
          onSuccess();
        }
      } else {
        if(onFailed != null) {
          onFailed(response.statusCode);
        }
      }
    }
    catch(e) {
      if(onFailed != null) {
        onFailed(null);
      }
    }

  }

  void deleteTheme({required AppTheme appTheme, void Function(int?)? onFailed , void Function()? onSuccess, bool postWebSocket = true}) async {


    try {
      final response = await delete(
        Uri.parse("${appSettings.serverAddress}/notes/themes/${appTheme.filename}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": appStorage.selectedUser.token
        },
      );

      if (response.statusCode == 200) {
        if(onSuccess != null) {
          onSuccess();
        }
        if(postWebSocket) {
          UpdateEvent updateEvent = UpdateEvent(action: UpdateEvent.deleteTheme, value: appTheme.filename, date: DateTime.now());
          postWebSocketMessage(updateEvent.toJson());
        }

      } else {
        if(onFailed != null) {
          onFailed(response.statusCode);
        }
      }
    }
    catch(e) {
      if(onFailed != null) {
        onFailed(null);
      }
    }
  }
}