import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:notes/models/theme_model.dart';

import '../database/database_helper.dart';
import 'app_storage.dart';

final appSettings = AppSettings.getInstance();

ValueNotifier<AppSettings> notifier = ValueNotifier(appSettings);

class AppSettings {
  static final AppSettings _instance = AppSettings._internal();
  AppSettings._internal();

  static AppSettings getInstance() => _instance;

  ThemeModel themeModel = ThemeModel();

  String? get themeId => data["theme"];
  set themeId(value) => data["theme"] = value;

  Locale? locale = null;
  Map<String, dynamic> data = {};

  set serverAddress(value) => data["serverAddress"] = value;
  String get serverAddress => data.putIfAbsent("serverAddress", () => "");

  set useOwnServer(value) => data["useOwnServer"] = value;
  bool get useOwnServer => data.putIfAbsent("useOwnServer", () => false);

  set transparentNavigationBar(value) => data["transparentNavigationBar"] = value;
  bool get transparentNavigationBar => data.putIfAbsent("transparentNavigationBar", () => false);

  set permanentDeletionPeriod(value) => data["permanentDeletionPeriod"] = value;
  int get permanentDeletionPeriod => data.putIfAbsent("permanentDeletionPeriod", () => 30);

  set autoCheckUpdate(bool value) => data["autoCheckUpdate"] = value;
  bool get autoCheckUpdate => data["autoCheckUpdate"] ?? Platform.isWindows || Platform.isMacOS;

  set autoCheckServerUpdate(bool value) => data["autoCheckServerUpdate"] = value;
  bool get autoCheckServerUpdate => data["autoCheckServerUpdate"] ?? true;

  set windowButtonsOnLeft(bool value) => data["windowButtonsOnLeft"] = value;
  bool get windowButtonsOnLeft => data["windowButtonsOnLeft"] ?? false;

  set windowControlsStyle(String? value) => data["windowControlsStyle"] = value;
  String? get windowControlsStyle => data["windowControlsStyle"];

  set prefersCustomTitleBar(bool value) => data["prefersCustomTitleBar"] = value;
  bool get prefersCustomTitleBar => data["prefersCustomTitleBar"] ?? true;

  Future<void> getData() async {
    File file = File(appStorage.settingsPath);
    try {
      data = jsonDecode(file.readAsStringSync());

      if (data["locale"] != null) {
        locale = Locale(data["locale"]);
      }

      if(themeId != null) {
        final database = await databaseHelper.database;
        final List<Map<String, dynamic>> list = await database.rawQuery("SELECT * FROM themes WHERE id = ?", [themeId]);

        if(list.isNotEmpty) {
          themeModel = ThemeModel.fromMap(list.first);
        }
      }
    }
    catch(e) {
      data = {
        "theme": null,
        "serverAddress": "",
        "useOwnServer": false,
        "locale": null,
        "transparentNavigationBar": false,
        "dockedFloatingMenu": true,
        "permanentDeletionPeriod": 30,
        "floatingMenuShowing": true
      };
    }
  }

  Future<void> save() async {
    data["theme"] = themeModel.id;
    data["locale"] =  locale?.languageCode ?? null;

    File file = File( appStorage.settingsPath);
    await file.writeAsString(jsonEncode(data));
  }
}
