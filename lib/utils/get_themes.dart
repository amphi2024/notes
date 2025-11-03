import 'dart:io';


import 'package:notes/models/theme_model.dart';

import '../models/app_storage.dart';

List<ThemeModel> allThemes() {
  List<ThemeModel> list = [];
  ThemeModel themeModel = ThemeModel();

  list.add(themeModel);

  Directory directory = Directory(appStorage.themesPath);
  List<FileSystemEntity> fileList = directory.listSync();

  for (FileSystemEntity file in fileList) {
    if (file is File) {
      // AppTheme themeModel = AppTheme.fromFile(file);
      // list.add(themeModel);
    }
  }
  return list;
}
