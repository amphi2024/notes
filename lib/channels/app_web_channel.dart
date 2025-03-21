import 'dart:convert';
import 'dart:io';

import 'package:amphi/models/app_web_channel_core.dart';
import 'package:amphi/models/update_event.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:http/http.dart';
import 'package:notes/channels/app_web_download.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/folder.dart';
import 'package:notes/models/note.dart';
import 'package:web_socket_channel/io.dart';

import '../models/app_theme.dart';

final appWebChannel = AppWebChannel.getInstance();

class AppWebChannel extends AppWebChannelCore {
  static final AppWebChannel _instance = AppWebChannel._internal();

  AppWebChannel._internal();

  static AppWebChannel getInstance() => _instance;

  List<void Function(Note note)> noteUpdateListeners = [];
  List<void Function(Folder folder)> folderUpdateListeners = [];
  List<void Function(String)> userNameUpdateListeners = [];
  List<void Function(AppTheme)> appThemeUpdateListeners = [];
  
  get token => appStorage.selectedUser.token;

  get serverAddress => appSettings.serverAddress;

  @override
  Future<void> connectWebSocket() async => connectWebSocketSuper("/notes/sync");

  void setupWebsocketChannel(String address) async {
    webSocketChannel = IOWebSocketChannel.connect(address, headers: {"Authorization": appWebChannel.token});

    webSocketChannel?.stream.listen((message) async {
      Map<String, dynamic> jsonData = jsonDecode(message);
      UpdateEvent updateEvent = UpdateEvent.fromJson(jsonData);

      switch (updateEvent.action) {
        case UpdateEvent.uploadNote:
          if (updateEvent.value.endsWith(".note")) {
            appWebChannel.downloadNote(
                filename: updateEvent.value,
                onSuccess: (note) {
                  for (var function in noteUpdateListeners) {
                    function(note);
                  }
                });
          } else if (updateEvent.value.endsWith(".folder")) {
            appWebChannel.downloadFolder(
                filename: updateEvent.value,
                onSuccess: (folder) {
                  for (var function in folderUpdateListeners) {
                    function(folder);
                  }
                });
          }
          break;
        case UpdateEvent.uploadTheme:
          appWebChannel.downloadTheme(filename: updateEvent.value, onSuccess: (appTheme) {
            for(var function in appThemeUpdateListeners) {
              function(appTheme);
            }
          });
          break;
        case UpdateEvent.renameUser:
          appStorage.selectedUser.name = updateEvent.value;
          appStorage.saveSelectedUserInformation();
          userNameUpdateListeners.forEach((fun) {
            fun(updateEvent.value);
          });
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

  void getFiles({required String noteName , void Function(int?)? onFailed, void Function(List<Map<String, dynamic>>)? onSuccess}) async {
    getItems(url: "$serverAddress/notes/$noteName/files", onSuccess: onSuccess, onFailed: onFailed);
  }

  void acknowledgeEvent(UpdateEvent updateEvent) async {
    Map<String, dynamic> data = {
      'value': updateEvent.value,
      'action': updateEvent.action,
    };

    String postData = json.encode(data);

    await delete(
      Uri.parse("$serverAddress/notes/events"),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": appWebChannel.token},
      body: postData,
    );
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
        UpdateEvent updateEvent = UpdateEvent(action: map["action"], value: map["value"], timestamp: DateTime.fromMillisecondsSinceEpoch( map["timestamp"]).toLocal());
        list.add(updateEvent);
      }
      onResponse(list);
    } else if (response.statusCode == HttpStatus.unauthorized) {
      appStorage.selectedUser.token = "";
    }
  }

}
