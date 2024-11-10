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


  void deleteFile({required String link, required String filename, void Function()? onSuccess, void Function(int?)? onFailed, bool postWebSocket = true}) async {
    try {

      final response = await delete(
        Uri.parse("${appSettings.serverAddress}/delete_$link?filename=${filename}"),
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
          UpdateEvent updateEvent = UpdateEvent(action: "delete_$link", value: filename, date: DateTime.now());
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

  void deleteFolder({required Folder folder, void Function(int?)? onFailed , void Function()? onSuccess, bool postWebSocket = true}) {
    deleteFile(link: "note", filename: folder.filename, onFailed:  onFailed, onSuccess: onSuccess, postWebSocket: postWebSocket);
  }

  void deleteNote({required Note note, void Function(int?)? onFailed , void Function()? onSuccess, bool postWebSocket = true}) {
    deleteFile(link: "note", filename: note.filename, onFailed:  onFailed, onSuccess:  onSuccess, postWebSocket: postWebSocket);

    for(Content content in note.contents) {
      // if (content.type == "img") {
      //   deleteFile(link: "note_image", filename: "${appStorage.notesPath}/${content.value}" , postWebSocket: postWebSocket, onFailed:  onFailed, onSuccess:  onSuccess,);
      // }
      // else if (content.type == "video") {
      //   deleteFile(link: "note_video",
      //       filename: "${appStorage.videosPath}/${content.value}", postWebSocket: postWebSocket, onFailed:  onFailed, onSuccess:  onSuccess,);
      // }
    }
  }

  void deleteTheme({required AppTheme appTheme, void Function(int?)? onFailed , void Function()? onSuccess, bool postWebSocket = true}) {
    deleteFile(link: "note_theme", filename: appTheme.filename, onFailed:  onFailed, onSuccess:  onSuccess, postWebSocket: postWebSocket);
  }
}