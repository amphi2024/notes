// ignore_for_file: constant_identifier_names
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/app_theme.dart';

final appSettings = AppSettings.getInstance();

class AppSettings {

  static final AppSettings _instance = AppSettings._internal();
  AppSettings._internal();

  static AppSettings getInstance() => _instance;

  late int fragmentIndex;
  // AppTheme   appTheme = AppTheme(
  //     created: DateTime.now(),
  //     modified: DateTime.now()
  // );
  AppTheme? appTheme = null;
  late String serverAddress;
  late bool useOwnServer;
  late int sortOption;
  late bool reverseSorting;
  late bool dancingFloatingButton;
  late bool iosStyleUI;
  late bool dockedFloatingMenu;
  Locale? locale = null;
  late int permanentDeletionPeriod;

  void setSortOption(int option) {
    if (sortOption == option) {
      reverseSorting = !reverseSorting;
    }
     sortOption = option;
  }

  void getData()  {
    File file = File(appStorage.settingsPath);
     if(!file.existsSync()) {
      fragmentIndex = 0;
      appTheme = AppTheme(
          created: DateTime.now(),
          modified: DateTime.now()
      );
      serverAddress = "";
      useOwnServer = false;
      sortOption = SORT_OPTION_MODIFIED_DATE;
      reverseSorting = false;
      dancingFloatingButton = true;
      iosStyleUI = false;
      dockedFloatingMenu = true;
      permanentDeletionPeriod = 30;
      save();
    }
    else {
      String jsonString = file.readAsStringSync();
      Map<String, dynamic> jsonData = jsonDecode(jsonString);
      fragmentIndex = jsonData["fragmentIndex"] ?? 0;
     String themeFilename = jsonData["theme"] ?? "!DEFAULT";
      File themeFile = File("${appStorage.themesPath}/$themeFilename");
     if(themeFilename != "!DEFAULT" && themeFile.existsSync()) {
         appTheme = AppTheme.fromFile(themeFile);
      }
     else {
       appTheme = AppTheme(
           created: DateTime.now(),
           modified: DateTime.now()
       );
     }

      iosStyleUI = jsonData["iosStyleUI"] ?? false;
      serverAddress = jsonData["serverAddress"] ?? "";
      useOwnServer = jsonData["useOwnServer"] ?? false;
      sortOption = jsonData["sortOption"] ?? 0;
      reverseSorting = jsonData["reverseSorting"] ?? false;
      if(jsonData["locale"] != null) {
        locale = Locale(jsonData["language"]);
      }
      dockedFloatingMenu = jsonData["showingFloatingMenu"] ?? true;
      permanentDeletionPeriod = jsonData["permanentDeletionPeriod"] ?? 30;
    }
  }

  Future<void> save() async {
    Map<String, dynamic> jsonData = {
      "fragmentIndex": fragmentIndex,
      "theme": appTheme!.filename,
      "serverAddress" : serverAddress,
      "useOwnServer" : useOwnServer,
      "sortOption" : sortOption,
      "reverseSorting" : reverseSorting,
      "locale": locale?.languageCode ?? null,
      "iosStyleUI": iosStyleUI,
      "dockedFloatingMenu": dockedFloatingMenu,
      "permanentDeletionPeriod": permanentDeletionPeriod
    };

    File file = File(appStorage.selectedUser.storagePath+"/settings.json");
    file.writeAsString(jsonEncode(jsonData));

  }

}

const int SORT_OPTION_TITLE = 0;
const int SORT_OPTION_CREATE_DATE = 1;
const int SORT_OPTION_MODIFIED_DATE = 2;
const int SORT_OPTION_DELETED_DATE = 3;
