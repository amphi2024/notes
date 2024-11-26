import 'package:amphi/models/update_event.dart';
import 'package:amphi/utils/file_name_utils.dart';
import 'package:http/http.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/models/app_theme.dart';
import 'package:notes/models/content.dart';
import 'package:notes/models/folder.dart';
import 'package:notes/models/note.dart';

extension AppWebDelete on AppWebChannel {

  void deleteItem({required String url, void Function(int?)? onFailed, void Function()? onSuccess, required UpdateEvent updateEvent}) async {
    try {
      final response = await delete(
        Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": token},
      );

      if (response.statusCode == 200) {
        if (onSuccess != null) {
          onSuccess();
        }
        postWebSocketMessage(updateEvent.toWebSocketMessage());
      } else {
        if (onFailed != null) {
          onFailed(response.statusCode);
        }
      }
    } catch (e) {
      if (onFailed != null) {
        onFailed(null);
      }
    }
  }

  void deleteItemWithoutWebSocket({required String url, void Function(int?)? onFailed, void Function()? onSuccess}) async {
    try {
      final response = await delete(
        Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": token},
      );

      if (response.statusCode == 200) {
        if (onSuccess != null) {
          onSuccess();
        }
      } else {
        if (onFailed != null) {
          onFailed(response.statusCode);
        }
      }
    } catch (e) {
      if (onFailed != null) {
        onFailed(null);
      }
    }
  }

  void deleteFolder({required Folder folder, void Function(int?)? onFailed, void Function()? onSuccess}) async {
    UpdateEvent updateEvent = UpdateEvent(action: UpdateEvent.deleteNote, value: folder.filename, timestamp: DateTime.now());
    deleteItem(url: "$serverAddress/notes/${folder.filename}", updateEvent: updateEvent, onSuccess: onSuccess, onFailed: onFailed);
  }

  void deleteNote({required Note note, void Function(int?)? onFailed, void Function()? onSuccess, bool postWebSocket = true}) async {
    UpdateEvent updateEvent = UpdateEvent(action: UpdateEvent.deleteNote, value: note.filename, timestamp: DateTime.now());
    deleteItem(url: "$serverAddress/notes/${note.filename}", updateEvent: updateEvent,  onSuccess: onSuccess, onFailed: onFailed);

    String noteFileNameOnly = FilenameUtils.nameOnly(note.filename);
    for (Content content in note.contents) {
      if (content.type == "img") {
        deleteImage(noteFileNameOnly: noteFileNameOnly, imageFilename: content.value, onFailed: onFailed, onSuccess: onSuccess);
      } else if (content.type == "video") {
        deleteVideo(noteFileNameOnly: noteFileNameOnly, videoFilename: content.value);
      }
    }
  }

  void deleteImage(
      {required String noteFileNameOnly, required String imageFilename, void Function(int?)? onFailed, void Function()? onSuccess}) async {
    deleteItemWithoutWebSocket(url: "$serverAddress/notes/${noteFileNameOnly}/images/${imageFilename}", onSuccess: onSuccess, onFailed: onFailed);
  }

  void deleteVideo(
      {required String noteFileNameOnly, required String videoFilename, void Function(int?)? onFailed, void Function()? onSuccess}) async {
    deleteItemWithoutWebSocket(url: "$serverAddress/notes/${noteFileNameOnly}/videos/${videoFilename}", onSuccess: onSuccess, onFailed: onFailed);
  }

  void deleteTheme({required AppTheme appTheme, void Function(int?)? onFailed, void Function()? onSuccess, bool postWebSocket = true}) async {
    UpdateEvent updateEvent = UpdateEvent(action: UpdateEvent.deleteTheme, value: appTheme.filename, timestamp: DateTime.now());
    deleteItem(url: "$serverAddress/notes/themes/${appTheme.filename}", updateEvent: updateEvent, onFailed: onFailed, onSuccess: onSuccess);
  }
}
