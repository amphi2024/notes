import 'package:http/http.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/content.dart';
import 'package:notes/models/folder.dart';
import 'package:notes/models/note.dart';
import 'package:amphi/models/update_event.dart';

extension AppWebUpload on AppWebChannel {

  void uploadTheme({required String themeFileContent, required String themeFilename, void Function()? onSuccess, void Function()? onFailed}) async {
    try {
      final response = await post(
          Uri.parse("${appSettings.serverAddress}/notes/themes/${themeFilename}"),
          headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": appStorage.selectedUser.token},
          body: themeFileContent
      );
      if (response.statusCode == 200) {
        if(onSuccess != null) {
          onSuccess();
        }
          UpdateEvent updateEvent = UpdateEvent(action: UpdateEvent.uploadTheme, value: themeFileContent, date: DateTime.now());
          postWebSocketMessage(updateEvent.toJson());

      } else {
        if(onFailed != null) {
          onFailed();
        }
      }
    } catch (e) {
      if (onFailed != null) {
        onFailed();
      }
    }
  }

  void uploadColors({required String colorsFileContent, void Function()? onSuccess, void Function()? onFailed}) async {
    try {
      final response = await post(
          Uri.parse("${appSettings.serverAddress}/notes/colors"),
          headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": appStorage.selectedUser.token},
          body: colorsFileContent
      );
      if (response.statusCode == 200) {
        if(onSuccess != null) {
          onSuccess();
        }
          UpdateEvent updateEvent = UpdateEvent(action: UpdateEvent.uploadColors, value: colorsFileContent, date: DateTime.now());
          postWebSocketMessage(updateEvent.toJson());

      } else {
        if(onFailed != null) {
          onFailed();
        }
      }
    } catch (e) {
      if (onFailed != null) {
        onFailed();
      }
    }
  }

  void uploadNote({required Note note, required String fileContent, void Function()? onFailed , Function? onSuccess, bool postWebSocket = true}) async {

    try {
      final response = await post(
        Uri.parse("${appSettings.serverAddress}/notes/${note.filename}"),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": appStorage.selectedUser.token},
        body: fileContent
      );
        if (response.statusCode == 200) {
          print("34234 ${response.statusCode},  ${response.body}");
          if(onSuccess != null) {
            onSuccess();
          }
          if(postWebSocket) {
            UpdateEvent updateEvent = UpdateEvent(action: UpdateEvent.uploadNote, value: note.filename, date: DateTime.now());
            postWebSocketMessage(updateEvent.toJson());
          }
        } else {
          if(onFailed != null) {
            onFailed();
          }
        }
    } catch (e) {
      if (onFailed != null) {
        onFailed();
      }
    }


    for(Content content in note.contents) {
      if (content.type == "img") {
        uploadImage(noteFileNameOnly: note.filename.split(".").first, imageFilename: content.value);
        // uploadFile(linkPath: "notes/images",
        //     filePath: "${appStorage.imagesPath}/${content.value}" , postWebSocket: postWebSocket, eventName: UpdateEvent.uploadImage);
      }
      else if (content.type == "video") {
        uploadVideo(noteFileNameOnly: note.filename.split(".").first, videoFilename: content.value);
      }
      else if(content.type == "table" && content.value is List<List<Map<String, dynamic>>>) {
        for(List<Map<String, dynamic>> rows in content.value) {
          for(Map<String, dynamic> cell in rows) {
            if(cell["img"] != null) {
              uploadImage(noteFileNameOnly: note.filename.split(".").first, imageFilename: cell["img"]);
              // uploadFile(linkPath: "notes/images",
              //     filePath: "${appStorage.imagesPath}/${cell["img"]}" , postWebSocket: postWebSocket, eventName: UpdateEvent.uploadImage);
            }
            else if(cell["video"] != null) {
              uploadVideo(noteFileNameOnly: note.filename.split(".").first, videoFilename: cell["video"]);
              // uploadFile(linkPath: "notes/videos",
              //     filePath: "${appStorage.videosPath}/${cell["video"]}", postWebSocket: postWebSocket, eventName: UpdateEvent.uploadVideo);
            }
          }
        }
      }
    }
  }

  void uploadFolder({required Folder folder, required String fileContent, void Function()? onFailed , Function? onSuccess, bool postWebSocket = true}) async {

    try {
      final response = await post(
          Uri.parse("${appSettings.serverAddress}/notes/${folder.filename}"),
          headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": appStorage.selectedUser.token},
          body: fileContent
      );
      if (response.statusCode == 200) {
        if(onSuccess != null) {
          onSuccess();
        }
        if(postWebSocket) {
          UpdateEvent updateEvent = UpdateEvent(action: UpdateEvent.uploadNote, value: folder.filename, date: DateTime.now());
          postWebSocketMessage(updateEvent.toJson());
        }
      } else {
        if(onFailed != null) {
          onFailed();
        }
      }
    } catch (e) {
      if (onFailed != null) {
        onFailed();
      }
    }

  }

  void uploadImage({required String noteFileNameOnly, required String imageFilename ,void Function(StreamedResponse?)? onFailed , Function? onSuccess}) async {
    try {

      MultipartRequest request = MultipartRequest('POST', Uri.parse("${appSettings.serverAddress}/notes/${noteFileNameOnly}/images/${imageFilename}"));
      MultipartFile multipartFile = await MultipartFile.fromPath("file", "${appStorage.notesPath}/${noteFileNameOnly}/images/${imageFilename}");

      request.headers.addAll({
        "Authorization": appStorage.selectedUser.token
      });
      request.files.add(multipartFile);
      var response = await request.send();

      if (response.statusCode == 200) {
        if(onSuccess != null) {
          onSuccess();
        }
      } else {
        if(onFailed != null) {
          onFailed(response);
        }
      }
    }
    catch(e)  {
      if(onFailed != null) {
        onFailed(null);
      }
    }
  }

  void uploadVideo({required String noteFileNameOnly, required String videoFilename ,void Function(StreamedResponse?)? onFailed , Function? onSuccess}) async {
    try {

      MultipartRequest request = MultipartRequest('POST', Uri.parse("${appSettings.serverAddress}/notes/${noteFileNameOnly}/videos/${videoFilename}"));
      MultipartFile multipartFile = await MultipartFile.fromPath("file", "${appStorage.notesPath}/${noteFileNameOnly}/videos/${videoFilename}");

      request.headers.addAll({
        "Authorization": appStorage.selectedUser.token
      });
      request.files.add(multipartFile);
      var response = await request.send();

      if (response.statusCode == 200) {
        if(onSuccess != null) {
          onSuccess();
        }
      } else {
        if(onFailed != null) {
          onFailed(response);
        }
      }
    }
    catch(e)  {
      if(onFailed != null) {
        onFailed(null);
      }
    }
  }

}