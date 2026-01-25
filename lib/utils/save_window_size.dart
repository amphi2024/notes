import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:window_manager/window_manager.dart';

import '../models/app_cache_data.dart';

Future<void> saveWindowSize() async {
  if(Platform.isWindows || Platform.isMacOS) {
    appCacheData.windowWidth = appWindow.size.width;
    appCacheData.windowHeight = appWindow.size.height;
  }
  else {
    appCacheData.windowWidth = (await windowManager.getSize()).width;
    appCacheData.windowHeight = (await windowManager.getSize()).height;
  }
  await appCacheData.save();
}