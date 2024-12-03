// ignore_for_file: constant_identifier_names
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:amphi/utils/path_utils.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/app_theme.dart';

final appSettings = AppSettings.getInstance();

class AppSettings {
  static final AppSettings _instance = AppSettings._internal();
  AppSettings._internal();

  static AppSettings getInstance() => _instance;

  AppTheme? appTheme = null;
  Locale? locale = null;
  late Map<String, dynamic> data;

  set viewMode(value) => data["viewMode"] = value;
  String get viewMode => data.putIfAbsent("viewMode", () => "linear");

  set serverAddress(value) => data["serverAddress"] = value;
  String get serverAddress => data.putIfAbsent("serverAddress", () => "");

  set useOwnServer(value) => data["useOwnServer"] = value;
  bool get useOwnServer => data.putIfAbsent("useOwnServer", () => false);

  String get sortBy => data.putIfAbsent("sortBy", () => "modified");

  bool get descending => data.putIfAbsent("descending", () => false);

  set transparentNavigationBar(value) => data["transparentNavigationBar"] = value;
  bool get transparentNavigationBar => data.putIfAbsent("transparentNavigationBar", () => false);

  set dockedFloatingMenu(value) => data["dockedFloatingMenu"] = value;
  bool get dockedFloatingMenu => data.putIfAbsent("dockedFloatingMenu", () => true);

  set permanentDeletionPeriod(value) => data["permanentDeletionPeriod"] = value;
  int get permanentDeletionPeriod => data.putIfAbsent("permanentDeletionPeriod", () => 30);

  set floatingMenuShowing(value) => data["floatingMenuShowing"] = value;
  bool get floatingMenuShowing => data.putIfAbsent("floatingMenuShowing", () => true);

  void setSortOption(String option) {
    if (sortBy == option) {
      data["descending"] = !descending;
    }
    data["sortBy"] = option;
  }

  void getData() {
    File file = File(appStorage.settingsPath);
    if (!file.existsSync()) {
      appTheme = AppTheme(created: DateTime.now(), modified: DateTime.now());
      data = {
        "viewMode": "linear",
        "theme": appTheme!.filename,
        "serverAddress": "",
        "useOwnServer": false,
        "sortBy": "modified",
        "descending": false,
        "locale": locale?.languageCode ?? null,
        "transparentNavigationBar": false,
        "dockedFloatingMenu": true,
        "permanentDeletionPeriod": 30,
        "floatingMenuShowing": true
      };
      save();
    } else {
      data = jsonDecode(file.readAsStringSync());

      String themeFilename = data["theme"] ?? "!DEFAULT";
      File themeFile = File(PathUtils.join(appStorage.themesPath, themeFilename));
      if (themeFilename != "!DEFAULT" && themeFile.existsSync()) {
        appTheme = AppTheme.fromFile(themeFile);
      } else {
        appTheme = AppTheme(created: DateTime.now(), modified: DateTime.now());
      }


      if (data["locale"] != null) {
        locale = Locale(data["locale"]);
      }
    }
  }

  Future<void> save() async {
    data["theme"] = appTheme!.filename;
    data["locale"] =  locale?.languageCode ?? null;

    File file = File( appStorage.settingsPath);
    file.writeAsString(jsonEncode(data));
  }
}
