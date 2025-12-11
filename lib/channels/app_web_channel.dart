import 'dart:convert';
import 'dart:io';
import 'package:amphi/models/app_web_channel_core.dart';
import 'package:amphi/models/update_event.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/file_model.dart';
import 'package:notes/models/theme_model.dart';

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

  bool uploadBlocked = false;

  @override
  String get appType => "notes";

  void setupWebsocketChannel(String address) async {
    webSocketChannel = IOWebSocketChannel.connect(address, headers: {"Authorization": appWebChannel.token});

    webSocketChannel?.stream.listen((message) async {
      Map<String, dynamic> jsonData = jsonDecode(message);
      UpdateEvent updateEvent = UpdateEvent.fromJson(jsonData);

      onWebSocketEvent(updateEvent);
      // appWebChannel.acknowledgeEvent(updateEvent);
    }, onDone: () {
      connected = false;
    }, onError: (d) {
      connected = false;
    }, cancelOnError: true);
  }

  void getNotes({void Function(int?)? onFailed, void Function(Set<Map<String, dynamic>>)? onSuccess}) async {
    getItems(url: "$serverAddress/notes", onFailed: onFailed, onSuccess: onSuccess);
  }

  void getThemes({void Function(int?)? onFailed, void Function(Set<Map<String, dynamic>>)? onSuccess}) async {
    getItems(url: "$serverAddress/notes/themes", onFailed: onFailed, onSuccess: onSuccess);
  }

  void getFiles({required String noteId, void Function(int?)? onFailed, void Function(Set<Map<String, dynamic>>)? onSuccess}) async {
    getItems(url: "$serverAddress/notes/$noteId/files", onSuccess: onSuccess, onFailed: onFailed);
  }

  @override
  Future<void> simpleDelete({required String url, void Function()? onSuccess, void Function(int?)? onFailed, required UpdateEvent updateEvent}) async {
    if(uploadBlocked) {
      return;
    }
    await super.simpleDelete(url: url, updateEvent: updateEvent, onFailed: onFailed, onSuccess: onSuccess);
  }

  Future<void> deleteNote({required Note note}) async {
    final updateEvent = UpdateEvent(action: UpdateEvent.deleteNote, value: note.id);
    await simpleDelete(url: "$serverAddress/notes/${note.id}", updateEvent: updateEvent);
  }


  Future<void> postJson(
      {required String url,
        required String jsonBody,
        void Function()? onSuccess,
        void Function(int?)? onFailed,
        required UpdateEvent updateEvent}) async {
    if(uploadBlocked) {
      return;
    }
    await super.postJson(url: url, jsonBody: jsonBody, updateEvent: updateEvent, onFailed: onFailed, onSuccess: onSuccess);
  }

  Future<void> uploadNote(Note note) async {
    final updateEvent = UpdateEvent(action: UpdateEvent.uploadNote, value: note.id);
    await postJson(url: "$serverAddress/notes/${note.id}", jsonBody: jsonEncode(note.toMap()), updateEvent: updateEvent);
    await uploadMissingAttachments(note, "audio", "audio");
    await uploadMissingAttachments(note, "videos", "video");
    await uploadMissingAttachments(note, "images", "img");
  }

  Future<void> uploadNoteFile({required String noteId, required FileModel fileModel, required void Function() onSuccess, void Function(int?)? onFailed, required void Function(int, int) onProgress}) async {
    await postFile(url: "$serverAddress/notes/$noteId/files/${fileModel.filename}", filePath: fileModel.originalPath!, onFailed: onFailed, onSuccess: onSuccess, onProgress: onProgress);
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
              if (item["value"] == fileInfo["filename"] && fileInfo["size"] == fileSize) {
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

  Future<void> downloadNoteFile({required String noteId, required String filename, required void Function() onSuccess, required void Function(int?) onFailed, required String saveFilePath, required void Function(int, int) onProgress}) async {
    await downloadFile(url: "$serverAddress/notes/$noteId/files/$filename", filePath: saveFilePath, onSuccess: onSuccess, onProgress: onProgress);
  }

  Future<void> uploadThemeModel(ThemeModel themeModel) async {
    final updateEvent = UpdateEvent(action: UpdateEvent.uploadTheme, value: themeModel.id);
    await postJson(url: "$serverAddress/notes/themes/${themeModel.id}", jsonBody: jsonEncode(themeModel.toMap()), updateEvent: updateEvent);
  }

  Future<void> downloadTheme({required String id, required void Function(ThemeModel themeModel) onSuccess, void Function(int?)? onFailed}) async {
    await downloadJson(
        url: "$serverAddress/notes/themes/$id",
        onSuccess: (data) {
          onSuccess(ThemeModel.fromMap(data));
        });
  }

  Future<void> deleteTheme(ThemeModel themeModel) async {
    final updateEvent = UpdateEvent(action: UpdateEvent.deleteTheme, value: themeModel.id);
    await simpleDelete(url: "$serverAddress/notes/themes/${themeModel.id}", updateEvent: updateEvent);
  }
}