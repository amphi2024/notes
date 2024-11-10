import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:notes/extensions/date_extension.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_storage.dart';
import 'package:amphi/models/update_event.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final appWebChannel = AppWebChannel.getInstance();

class AppWebChannel {
  static final AppWebChannel _instance = AppWebChannel._internal();

  AppWebChannel._internal();

  static AppWebChannel getInstance() => _instance;

  static const int failedToConnect = -1;
  static const int failedToAuth = -2;
  bool connected = false;
  WebSocketChannel? webSocketChannel;
  List<void Function(UpdateEvent updateEvent)> webSocketListeners = [];
  late String deviceName;

  Future<void> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo android = await deviceInfoPlugin.androidInfo;
      deviceName = android.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo ios = await deviceInfoPlugin.iosInfo;
      deviceName = ios.model;
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windows = await deviceInfoPlugin.windowsInfo;
      deviceName = windows.computerName;
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo mac = await deviceInfoPlugin.macOsInfo;
      deviceName = mac.model;
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linux = await deviceInfoPlugin.linuxInfo;
      deviceName = linux.name;
    }
  }

  void addWebSocketListener(void Function(UpdateEvent updateEvent) function) {
    webSocketListeners.add(function);
  }

  void removeWebSocketListener(void Function(UpdateEvent updateEvent) function) {
    webSocketListeners.remove(function);
  }

  void disconnectWebSocket() {
    webSocketChannel?.sink.close();
  }

  void setupWebsocketChannel(String serverAddress) async {
    webSocketChannel = IOWebSocketChannel.connect(serverAddress, headers: {"Authorization": appStorage.selectedUser.token});

    webSocketChannel?.stream.listen((message) async {
      try {
        Map<String, dynamic> jsonData = jsonDecode(message);
        UpdateEvent updateEvent = UpdateEvent(action: jsonData["action"], value: jsonData["value"], date: parsedDateTime(jsonData["date"]));
        for (void Function(UpdateEvent updateEvent) function in webSocketListeners) {
          function(updateEvent);
        }
      } catch (e) {
        for (void Function(UpdateEvent updateEvent) function in webSocketListeners) {
          function(UpdateEvent(action: "unknown", value: "", date: DateTime.now()));
        }
      }
    }, onDone: () {
      connected = false;
    }, onError: (d) {
      connected = false;
    }, cancelOnError: true);
  }

  Future<void> connectWebSocket() async {
    try {
      if (appSettings.serverAddress.startsWith("https://")) {
        String serverAddress = "wss://${appSettings.serverAddress.split("https://").last}/notes/sync";
        setupWebsocketChannel(serverAddress);
      } else if (appSettings.serverAddress.startsWith("http://")) {
        String serverAddress = "ws://${AppSettings.getInstance().serverAddress.split("http://").last}/notes/sync";
        setupWebsocketChannel(serverAddress);
      }
    } on WebSocketChannelException {
      connected = false;
    }
  }

  void postWebSocketMessage(String message) {
    if (webSocketChannel != null) {
      webSocketChannel?.sink.add(message);
    } else {
      connectWebSocket();
      webSocketChannel?.sink.add(message);
    }
  }

  void logout({required void Function() onLoggedOut, required void Function() onFailed}) async {
    try {
      final response = await get(
        Uri.parse("${appSettings.serverAddress}/users/logout"),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": appStorage.selectedUser.token},
      );
      if (response.statusCode == 200) {
        onLoggedOut();
      } else {
        onFailed();
      }
    } catch (e) {
      onFailed();
    }
  }

  void login(
      {required String id, required String password, required void Function(String, String) onLoggedIn, required void Function(int) onFailed}) async {
    Map<String, dynamic> data = {'id': id, 'password': password};

    String postData = json.encode(data);

    try {
      final response = await post(
        Uri.parse("${appSettings.serverAddress}/users/login"),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Device-Name": deviceName},
        body: postData,
      );
      String responseBody = utf8.decode(response.bodyBytes);
      String token = responseBody.split(";").first;
      String username = responseBody.split(";").last;
      if (token.isNotEmpty && response.statusCode == 200) {
        onLoggedIn(username, token);
      } else {
        onFailed(failedToAuth);
      }
    } catch (e) {
      onFailed(failedToConnect);
    }
  }

  void register(
      {required String id,
      required String name,
      required String password,
      required void Function() onRegistered,
      required void Function(int) onFailed}) async {
    Map<String, dynamic> data = {'id': id, 'password': password, "name": name};

    String postData = json.encode(data);

    try {
      final response = await post(
        Uri.parse("${appSettings.serverAddress}/users"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: postData,
      );
      String token = response.body;
      if (token.isNotEmpty && response.statusCode == 200) {
        onRegistered();
      } else {
        onFailed(failedToConnect);
      }
    } catch (e) {
      onFailed(failedToConnect);
    }
  }

  void changeUsername({required String name, required void Function() onSuccess, required void Function(int) onFailed}) async {
    Map<String, dynamic> data = {"name": name};

    String postData = json.encode(data);

    try {
      final response = await patch(
        Uri.parse("${appSettings.serverAddress}/users/name"),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": appStorage.selectedUser.token},
        body: postData,
      );
      if (response.statusCode == 200) {
        onSuccess();

        UpdateEvent updateEvent = UpdateEvent(action: "rename_user", value: name, date: DateTime.now());
        postWebSocketMessage(updateEvent.toJson());
      } else {
        onFailed(failedToAuth);
      }
    } catch (e) {
      onFailed(failedToConnect);
    }
  }

  void changePassword(
      {required String id,
      required String password,
      required String oldPassword,
      required void Function() onSuccess,
      required void Function(int) onFailed}) async {
    Map<String, dynamic> data = {"id": id, "password": password, "old_password": oldPassword};

    String postData = json.encode(data);

    try {
      final response = await patch(
        Uri.parse("${appSettings.serverAddress}/users/${id}/password"),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: postData,
      );
      if (response.statusCode == 200) {
        onSuccess();
      } else if (response.statusCode == 400) {
        onFailed(failedToAuth);
      } else {
        onFailed(failedToConnect);
      }
    } catch (e) {
      onFailed(failedToConnect);
    }
  }

  void getUserIds({required void Function(List<String>) onResponse, required void Function() onFailed}) async {
    try {
      final response = await get(Uri.parse("${appSettings.serverAddress}/users"));
      String body = utf8.decode(response.bodyBytes);
      List<dynamic> list = jsonDecode(body);
      List<String> result = [];
      for (dynamic data in list) {
        if (data is String) {
          result.add(data);
        }
      }
      onResponse(result);
    } catch (e) {
      onFailed();
    }
  }

  void getStorageInfo({required void Function(Map<String, dynamic>) onSuccess, required void Function() onFailed}) async {
    try {
      final response = await get(Uri.parse("${appSettings.serverAddress}/storage")).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        onSuccess(jsonDecode(response.body));
      } else {
        onFailed();
      }
    } catch(e) {
      onFailed();
    }
  }

  void getFiles({required String path, void Function()? onFailed, void Function(List<dynamic>)? onSuccess}) async {
    try {
      final response = await get(
        Uri.parse("${appSettings.serverAddress}/$path"),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": appStorage.selectedUser.token},
      );
      if (onSuccess != null && response.statusCode == 200) {
        onSuccess(jsonDecode(response.body));
      } else {

        if (onFailed != null) {

          onFailed();
        }
      }
    } catch (e) {
      if (onFailed != null) {
        onFailed();
      }
    }
  }


  void getImages({required String noteFilename, void Function()? onFailed, void Function(List<dynamic>)? onSuccess}) async {
    try {
      final response = await get(
        Uri.parse("${appSettings.serverAddress}/notes/${noteFilename}/images"),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": appStorage.selectedUser.token},
      );
      if (onSuccess != null && response.statusCode == 200) {
        onSuccess(jsonDecode(response.body));
      } else {

        if (onFailed != null) {

          onFailed();
        }
      }
    } catch (e) {
      if (onFailed != null) {
        onFailed();
      }
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

  void getEvents({required void Function(List<UpdateEvent>) onResponse}) async {
    List<UpdateEvent> list = [];
    final response = await get(
      Uri.parse("${AppSettings.getInstance().serverAddress}/notes/events"),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": appStorage.selectedUser.token},
    );
    if (response.statusCode == 200) {
      List<dynamic> decoded = jsonDecode(utf8.decode(response.bodyBytes));
      for (Map<String, dynamic> map in decoded) {
        String dateString = map["date"];
        UpdateEvent updateEvent = UpdateEvent(action: map["action"], value: map["value"], date: parsedDateTime(dateString));
        list.add(updateEvent);
      }
      onResponse(list);
    } else if (response.statusCode == 401) {
      appStorage.selectedUser.token = "";
    }
  }
}
