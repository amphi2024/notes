import 'dart:convert';
import 'dart:io';
import 'package:amphi/models/app_web_channel_core.dart';
import 'package:amphi/models/update_event.dart';
import 'package:http/http.dart';
import 'package:notes/models/app_settings.dart';

import 'package:notes/models/note.dart';
import 'package:notes/utils/attachment_path.dart';
import 'package:web_socket_channel/io.dart';

import '../models/app_storage.dart';

final appWebChannel = AppWebChannel.getInstance();

class AppWebChannel extends AppWebChannelCore {
  static final AppWebChannel _instance = AppWebChannel._internal();

  AppWebChannel._internal();

  static AppWebChannel getInstance() => _instance;

  get token => appStorage.selectedUser.token;

  get serverAddress => appSettings.serverAddress;

  late void Function(UpdateEvent) onWebSocketEvent;

  @override
  String get appType => "notes";

  void setupWebsocketChannel(String address) async {
    webSocketChannel = IOWebSocketChannel.connect(address, headers: {"Authorization": appWebChannel.token});

    webSocketChannel?.stream.listen((message) async {
      Map<String, dynamic> jsonData = jsonDecode(message);
      UpdateEvent updateEvent = UpdateEvent.fromJson(jsonData);

      onWebSocketEvent(updateEvent);
      appWebChannel.acknowledgeEvent(updateEvent);
    }, onDone: () {
      connected = false;
    }, onError: (d) {
      connected = false;
    }, cancelOnError: true);
  }

  void getItems({required String url, void Function(int?)? onFailed, void Function(List<Map<String, dynamic>>)? onSuccess}) async {
    try {
      final response = await get(
        Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": appWebChannel.token},
      );
      if (onSuccess != null && response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body);
        onSuccess(list.map((item) => item as Map<String, dynamic>).toList());
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

  void getNotes({void Function(int?)? onFailed, void Function(List<Map<String, dynamic>>)? onSuccess}) async {
    getItems(url: "$serverAddress/notes", onFailed: onFailed, onSuccess: onSuccess);
  }

  void getThemes({void Function(int?)? onFailed, void Function(List<Map<String, dynamic>>)? onSuccess}) async {
    getItems(url: "$serverAddress/notes/themes", onFailed: onFailed, onSuccess: onSuccess);
  }

  void getFiles({required String noteId, void Function(int?)? onFailed, void Function(List<Map<String, dynamic>>)? onSuccess}) async {
    getItems(url: "$serverAddress/notes/$noteId/files", onSuccess: onSuccess, onFailed: onFailed);
  }

  void getEvents({required void Function(List<UpdateEvent>) onResponse}) async {
    List<UpdateEvent> list = [];
    final response = await get(
      Uri.parse("$serverAddress/notes/events"),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": appWebChannel.token},
    );
    if (response.statusCode == HttpStatus.ok) {
      List<dynamic> decoded = jsonDecode(utf8.decode(response.bodyBytes));
      for (Map<String, dynamic> map in decoded) {
        UpdateEvent updateEvent = UpdateEvent.fromJson(map);
        list.add(updateEvent);
      }
      onResponse(list);
    } else if (response.statusCode == HttpStatus.unauthorized) {
      appStorage.selectedUser.token = "";
    }
  }

  void acknowledgeEvent(UpdateEvent updateEvent) async {
    Map<String, dynamic> data = {
      'value': updateEvent.value,
      'action': updateEvent.action,
    };

    String postData = json.encode(data);

    await delete(
      Uri.parse("${appSettings.serverAddress}/notes/events"),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": appStorage.selectedUser.token},
      body: postData,
    );
  }

  Future<void> deleteNote({required Note note}) async {
    final updateEvent = UpdateEvent(action: UpdateEvent.deleteNote, value: note.id);
    await simpleDelete(url: "$serverAddress/notes/${note.id}", updateEvent: updateEvent);
  }

  Future<void> uploadNote(Note note) async {
    final updateEvent = UpdateEvent(action: UpdateEvent.uploadNote, value: note.id);
    await postJson(url: "$serverAddress/notes/${note.id}", jsonBody: jsonEncode(note.toMap()), updateEvent: updateEvent);
    await uploadMissingAttachments(note, "audio", "audio");
    await uploadMissingAttachments(note, "videos", "video");
    await uploadMissingAttachments(note, "images", "img");
  }

  Future<void> uploadMissingAttachments(Note note, String directoryName, String type) async {
    getItems(
        url: "$serverAddress/notes/${note.id}/$directoryName",
        onSuccess: (list) async {
          for (var item in note.content) {
            bool exists = false;
            if (item["type"] != type) {
              continue;
            }
            var file = File(noteAttachmentPath(note.id, item["value"], directoryName));
            var fileSize = await file.length();
            for (var fileInfo in list) {

              if (item["value"] == fileInfo["filename"] && item["size"] == fileSize) {
                exists = true;
                break;
              }
            }

            if (!exists) {
              await postFile(url: "$serverAddress/notes/${note.id}/$directoryName/${item["value"]}", filePath: file.path);
            }
          }
        });
  }

  Future<void> downloadMissingAttachments(Note note, String directoryName, String type) async {
    getItems(
        url: "$serverAddress/notes/${note.id}/$directoryName",
        onSuccess: (list) async {
          for (var item in note.content) {
            bool exists = false;
            if (item["type"] != type) {
              continue;
            }
            var file = File(noteAttachmentPath(note.id, item["value"], directoryName));
            var fileSize = await file.length();
            for (var fileInfo in list) {

              if (item["value"] == fileInfo["filename"] && item["size"] == fileSize) {
                exists = true;
                break;
              }
            }

            if (!exists) {
              await downloadFile(url: "$serverAddress/notes/${note.id}/$directoryName/${item["value"]}", filePath: file.path);
            }
          }
        });
  }

  Future<void> downloadNote({required String id, required void Function(Note note) onSuccess, void Function(int?)? onFailed}) async {
    await downloadJson(
        url: "$serverAddress/notes/$id",
        onSuccess: (data) {
          onSuccess(Note.fromMap(data));
        });
  }

  Future<void> downloadNoteImage({required String id, required String filename}) async {
    var attachments = Directory(noteAttachmentDirPath(id, "images"));
    if (!await attachments.exists()) {
      attachments.create(recursive: true);
    }
    await downloadFile(url: "$serverAddress/notes/$id/images/$filename", filePath: noteImagePath(id, filename));
  }

  Future<void> downloadNoteVideo({required String id, required String filename, void Function()? onSuccess, void Function(int received, int total)? onProgress}) async {
    var attachments = Directory(noteAttachmentDirPath(id, "videos"));
    if (!await attachments.exists()) {
      attachments.create(recursive: true);
    }
    await downloadFile(url: "$serverAddress/notes/$id/videos/$filename", filePath: noteVideoPath(id, filename), onSuccess: onSuccess, onProgress: onProgress);
  }

  Future<void> downloadNoteAudio({required String id, required String filename, void Function()? onSuccess, void Function(int received, int total)? onProgress}) async {
    var attachments = Directory(noteAttachmentDirPath(id, "audio"));
    if (!await attachments.exists()) {
      attachments.create(recursive: true);
    }
    await downloadFile(url: "$serverAddress/notes/$id/audio/$filename", filePath: noteAudioPath(id, filename), onSuccess: onSuccess, onProgress: onProgress);
  }
}
