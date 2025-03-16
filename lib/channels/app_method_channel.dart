import 'dart:io';
import 'package:flutter/services.dart';

final appMethodChannel = AppMethodChannel.getInstance();

class AppMethodChannel extends MethodChannel {
  static final AppMethodChannel _instance = AppMethodChannel._internal("notes_method_channel");
  AppMethodChannel._internal(super.name) {
    setMethodCallHandler((call) async {
      switch (call.method) {
        default:
          break;
      }
      for(Function function in listeners) {
        function(call);
      }
    });
  }

  static AppMethodChannel getInstance() => _instance;

  List<Function> listeners = [];

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
}