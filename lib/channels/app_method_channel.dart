import 'dart:io';
import 'package:flutter/services.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/utils/save_window_size.dart';

final appMethodChannel = AppMethodChannel.getInstance();

class AppMethodChannel extends MethodChannel {
  static final AppMethodChannel _instance = AppMethodChannel._internal("notes_method_channel");
  AppMethodChannel._internal(super.name) {
    setMethodCallHandler((call) async {
      switch (call.method) {
        case "on_enter_fullscreen":
          for(var function in fullScreenListeners) {
            function(true);
          }
          break;
        case "on_exit_fullscreen":
          for(var function in fullScreenListeners) {
            function(false);
          }
          break;
        case "on_window_close":
          await saveWindowSize();
          break;
        default:
          break;
      }
    });
  }

  static AppMethodChannel getInstance() => _instance;

  List<void Function(bool)> fullScreenListeners = [];

  int systemVersion = 0;

  void createDirectoryIfNotExists(String path) {
    Directory directory = Directory(path);
    if(!directory.existsSync()) {
      directory.createSync();
    }
  }

  void rotateScreen() {
    invokeMethod("rotate_screen");
  }

  void setLandScape() {
    invokeMethod("set_landscape");
  }

  void setPortrait() {
    invokeMethod("set_portrait");
  }

  void setNavigationBarColor(Color color) {
    if(Platform.isAndroid) {
      invokeMethod("set_navigation_bar_color", {"color": color.toARGB32(), "transparent_navigationBar": appSettings.transparentNavigationBar});
    }
  }

  void getSystemVersion() async {
    systemVersion = await invokeMethod("get_system_version");
  }
}