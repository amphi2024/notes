import 'dart:io';

import 'package:notes/models/app_storage.dart';
import 'package:notes/models/app_theme.dart';

List<AppTheme> allThemes() {
  List<AppTheme> list = [];
  AppTheme appTheme = AppTheme(
    created: DateTime.now(),
    modified: DateTime.now()
  );

  list.add(appTheme);

  Directory directory = Directory("${appStorage.selectedUser.storagePath}/themes");
  List<FileSystemEntity> fileList = directory.listSync();

  for (FileSystemEntity file in fileList) {
  if(file is File) {
  AppTheme appTheme = AppTheme.fromFile(file);
    list.add(appTheme);
  }
  }
  return list;
}