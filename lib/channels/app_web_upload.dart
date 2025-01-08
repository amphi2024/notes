import 'package:amphi/models/update_event.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:http/http.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/content.dart';
import 'package:notes/models/folder.dart';
import 'package:notes/models/note.dart';

extension AppWebUpload on AppWebChannel {
  void uploadJson({required String url, required String jsonBody ,void Function()? onSuccess, void Function(int?)? onFailed, required UpdateEvent updateEvent}) async {
    try {
      final response = await post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": token},
          body: jsonBody);
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

  void uploadTheme({required String themeFileContent, required String themeFilename, void Function()? onSuccess, void Function(int?)? onFailed}) async {
    UpdateEvent updateEvent = UpdateEvent(action: UpdateEvent.uploadTheme, value: themeFilename, timestamp: DateTime.now().toUtc());
    uploadJson(url: "$serverAddress/notes/themes/${themeFilename}", jsonBody: themeFileContent, updateEvent: updateEvent, onSuccess: onSuccess, onFailed: onFailed);
  }

  void uploadColors({required String colorsFileContent, void Function()? onSuccess, void Function(int?)? onFailed}) async {
    UpdateEvent updateEvent = UpdateEvent(action: UpdateEvent.uploadColors, value: colorsFileContent, timestamp: DateTime.now().toUtc());
    uploadJson(url: "$serverAddress/notes/colors", jsonBody: colorsFileContent, updateEvent: updateEvent, onSuccess: onSuccess, onFailed: onFailed);
  }

  void uploadNote({required Note note, required String fileContent, void Function(int?)? onFailed, void Function()? onSuccess}) async {
    UpdateEvent updateEvent = UpdateEvent(action: UpdateEvent.uploadNote, value: note.filename, timestamp: DateTime.now().toUtc());
    uploadJson(url: "$serverAddress/notes/${note.filename}", jsonBody: fileContent, updateEvent: updateEvent, onSuccess: onSuccess, onFailed: onFailed);

    for (Content content in note.contents) {
      String noteName = note.name;
      if (content.type == "img") {
        uploadImage(noteName: noteName, imageFilename: content.value);
      } else if (content.type == "video") {
        uploadVideo(noteName: noteName, videoFilename: content.value);
      } else if (content.type == "table" && content.value is List<List<Map<String, dynamic>>>) {
        for (List<Map<String, dynamic>> rows in content.value) {
          for (Map<String, dynamic> cell in rows) {
            if (cell["img"] != null) {
              uploadImage(noteName: noteName, imageFilename: cell["img"]);
            } else if (cell["video"] != null) {
              uploadVideo(noteName: noteName, videoFilename: cell["video"]);
            }
          }
        }
      }
    }
  }

  void uploadFolder({required Folder folder, required String fileContent, void Function(int?)? onFailed, void Function()? onSuccess}) async {
    UpdateEvent updateEvent = UpdateEvent(action: UpdateEvent.uploadNote, value: folder.filename, timestamp: DateTime.now().toUtc());
    uploadJson(url: "$serverAddress/notes/${folder.filename}", jsonBody: fileContent, updateEvent: updateEvent, onSuccess: onSuccess, onFailed: onFailed);
  }

  void uploadFileOfNote({required String url, required String filePath, void Function()? onSuccess, void Function(int?)? onFailed}) async {
    try {
      MultipartRequest request = MultipartRequest('POST', Uri.parse(url));
      MultipartFile multipartFile =
      await MultipartFile.fromPath("file", filePath);

      request.headers.addAll({"Authorization": token});
      request.files.add(multipartFile);
      var response = await request.send();
      // Need to add something to indicate progressing later
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

  void uploadImage(
      {required String noteName, required String imageFilename, void Function(int?)? onFailed, void Function()? onSuccess}) async {
    uploadFileOfNote(url: "$serverAddress/notes/${noteName}/images/${imageFilename}", filePath: PathUtils.join(appStorage.notesPath, noteName, "images", imageFilename), onSuccess: onSuccess, onFailed:  onFailed);
  }

  void uploadVideo(
      {required String noteName, required String videoFilename, void Function(int?)? onFailed, void Function()? onSuccess}) async {
    uploadFileOfNote(url: "$serverAddress/notes/${noteName}/videos/${videoFilename}", filePath: PathUtils.join(appStorage.notesPath, noteName, "videos", videoFilename), onSuccess: onSuccess, onFailed:  onFailed);
  }

  void uploadFile({required String noteName, required String filename, void Function(int?)? onFailed, void Function()? onSuccess, required String filePath}) async{
    try {
      MultipartRequest request = MultipartRequest('POST', Uri.parse("$serverAddress/notes/${noteName}/files/${filename}"));
      MultipartFile multipartFile =
      await MultipartFile.fromPath("file", filePath);

      request.headers.addAll({"Authorization": token});
      request.files.add(multipartFile);
      var response = await request.send();
      // Need to add something to indicate progressing later
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
}
