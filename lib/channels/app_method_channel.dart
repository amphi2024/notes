import 'dart:io';
import 'package:flutter/services.dart';

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
        default:
          break;
      }
    });
  }

  static AppMethodChannel getInstance() => _instance;

  List<void Function(bool)> fullScreenListeners = [];

  int systemVersion = 0;
  bool needsBottomPadding = false;

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

  void setNavigationBarColor(Color color, bool iosLikeUi) {
    if(Platform.isAndroid) {
      invokeMethod("set_navigation_bar_color", {"color": color.value, "ios_like_ui": iosLikeUi});
    }
  }

  void getSystemVersion() async {
    systemVersion = await invokeMethod("get_system_version");
  }

  void configureNeedsBottomPadding() async {
    needsBottomPadding = await invokeMethod("configure_needs_bottom_padding");
  }

  void removeMacOsToolbar() async {
    if(Platform.isMacOS) {
      await invokeMethod("remove_mac_os_toolbar");
    }
  }

  void setMacOsToolbar() async {
    if(Platform.isMacOS) {
      await invokeMethod("set_mac_os_toolbar");
    }
  }
}