import 'dart:io';

import 'package:flutter/services.dart';

final appMethodChannel = AppMethodChannel.getInstance();

class AppMethodChannel extends MethodChannel {
  static final AppMethodChannel _instance = AppMethodChannel._internal("notes_method_channel");
  AppMethodChannel._internal(super.name) {
    setMethodCallHandler((call) async {
      switch (call.method) {
        // case "on_image_selected":
        //   String originalPath = call.arguments;
        //   String filename = generatedFileName(originalPath.split(".").last, appStorage.imagesPath);
        //
        //   File originalFile = File(originalPath);
        //   File file = File("${appStorage.imagesPath}/$filename");
        //   await originalFile.copy(file.path);
        //   onImageSelected(file.path);
        //   break;
        // case "on_video_selected":
        //   String originalPath = call.arguments;
        //   String filename = generatedFileName(originalPath.split(".").last, appStorage.videosPath);
        //
        //   File originalFile = File(originalPath);
        //   File file = File("${appStorage.videosPath}/$filename");
        //   await originalFile.copy(file.path);
        //   onVideoSelected(file.path);
        //   break;

        case "light_theme":
          break;
        case "dark_theme":
          break;
        default:
          break;
      }
      for(Function function in listeners) {
        function(call);
      }
    });
  }

  static AppMethodChannel getInstance() => _instance;

  //late void Function(String) onImageSelected;
  //late void Function(String) onVideoSelected;

  List<Function> listeners = [];

  int? systemVersion;

  void createDirectoryIfNotExists(String path) {
    Directory directory = Directory(path);
    if(!directory.existsSync()) {
      directory.createSync();
    }
  }

  void addListener(Function function) {
    listeners.add(function);
  }

  void removeListener(Function function) {
    listeners.remove(function);
  }

  void selectImage() async {
    await invokeMethod("select_image");
  }

  void selectImageFromFiles() async {
    await invokeMethod("select_image_from_files");
  }

  void selectVideo() async {
    await invokeMethod("select_video");
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

}