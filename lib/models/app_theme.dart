import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/channels/app_web_upload.dart';
import 'package:notes/models/dark_theme.dart';
import 'package:notes/models/light_theme.dart';
import 'package:amphi/models/app_theme_core.dart';

class AppTheme extends AppThemeCore {

  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color lightGray = Color.fromRGBO(245, 245, 245, 1);
  static const Color black = Color.fromRGBO(0, 0, 0, 1);
  static const Color lightBlue = Color.fromRGBO(0, 140, 255, 1.0);
  static const Color skyBlue = Color.fromRGBO(70, 180, 255, 1.0);
  static const Color midnight = Color.fromRGBO(35, 35, 35, 1.0);
  static const Color inactiveGray = Color(0xFF999999);
  static const Color yellow = Color(0xFFFFF176);
  static const Color charCoal = Color.fromRGBO(45, 45, 45, 1.0);
  static const Color transparent =Color(0x00000000);
  static const Color red =Color(0xFFFF1F24);

  LightTheme lightTheme = LightTheme();
  DarkTheme darkTheme = DarkTheme();

  AppTheme(
      {
        super.title = "",
        super.filename = "!DEFAULT",
        required super.created,
        required super.modified,
        super.path = ""
      });

  static AppTheme fromFile(File file) {

      String jsonString = file.readAsStringSync();
      Map<String, dynamic> jsonData = jsonDecode(jsonString);

      AppTheme appTheme = AppTheme(
          created: DateTime.fromMillisecondsSinceEpoch(jsonData["created"]).toLocal(),
          modified: DateTime.fromMillisecondsSinceEpoch(jsonData["modified"]).toLocal(),
          path: file.path,
          filename: file.path
              .split("/")
              .last
      );
      appTheme.title = jsonData["title"];

      appTheme.lightTheme.backgroundColor =
          Color(jsonData["lightBackgroundColor"]);
      appTheme.lightTheme.textColor = Color(jsonData["lightTextColor"]);
      appTheme.lightTheme.accentColor = Color(jsonData["lightAccentColor"]);
      appTheme.lightTheme.inactiveColor = Color(jsonData["lightInactiveColor"]);
      appTheme.lightTheme.noteBackgroundColor =
          Color(jsonData["lightNoteBackgroundColor"]);
      appTheme.lightTheme.noteTextColor = Color(jsonData["lightNoteTextColor"]);
      appTheme.lightTheme.floatingButtonBackground =
          Color(jsonData["lightFloatingButtonBackground"]);
      appTheme.lightTheme.floatingButtonIconColor =
          Color(jsonData["lightFloatingButtonIconColor"]);
      appTheme.lightTheme.checkBoxColor = Color(jsonData["lightCheckBoxColor"]);
      appTheme.lightTheme.checkBoxCheckColor =
          Color(jsonData["lightCheckBoxCheckColor"]);

      appTheme.darkTheme.backgroundColor =
          Color(jsonData["darkBackgroundColor"]);
      appTheme.darkTheme.textColor = Color(jsonData["darkTextColor"]);
      appTheme.darkTheme.accentColor = Color(jsonData["darkAccentColor"]);
      appTheme.darkTheme.inactiveColor = Color(jsonData["darkInactiveColor"]);
      appTheme.darkTheme.noteBackgroundColor =
          Color(jsonData["darkNoteBackgroundColor"]);
      appTheme.darkTheme.noteTextColor = Color(jsonData["darkNoteTextColor"]);
      appTheme.darkTheme.floatingButtonBackground =
          Color(jsonData["darkFloatingButtonBackground"]);
      appTheme.darkTheme.floatingButtonIconColor =
          Color(jsonData["darkFloatingButtonIconColor"]);
      appTheme.darkTheme.checkBoxColor = Color(jsonData["darkCheckBoxColor"]);
      appTheme.darkTheme.checkBoxCheckColor =
          Color(jsonData["darkCheckBoxCheckColor"]);

      return appTheme;
  }

  Future<void> save({bool upload = true}) async {
    await saveFile((fileContent) {
      appWebChannel.uploadTheme(themeFileContent: fileContent, themeFilename: filename);
    });
  }

  Future<void> delete({bool upload = true}) async {
    await super.deleteFile();
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "created": created.toUtc().millisecondsSinceEpoch,
      "modified": modified.toUtc().millisecondsSinceEpoch,

      "lightBackgroundColor": lightTheme.backgroundColor.toHex(),
      "lightTextColor":  lightTheme.textColor.toHex(),
      "lightAccentColor":  lightTheme.accentColor.toHex(),
      "lightInactiveColor":  lightTheme.inactiveColor.toHex(),
      "lightNoteBackgroundColor":  lightTheme.noteBackgroundColor.toHex(),
      "lightNoteTextColor":  lightTheme.noteTextColor.toHex(),
      "lightFloatingButtonBackground":  lightTheme.floatingButtonBackground.toHex(),
      "lightFloatingButtonIconColor":  lightTheme.floatingButtonIconColor.toHex(),
      "lightCheckBoxColor":  lightTheme.checkBoxColor.toHex(),
      "lightCheckBoxCheckColor":  lightTheme.checkBoxCheckColor.toHex(),

      "darkBackgroundColor": darkTheme.backgroundColor.toHex(),
      "darkTextColor":  darkTheme.textColor.toHex(),
      "darkAccentColor":  darkTheme.accentColor.toHex(),
      "darkInactiveColor":  darkTheme.inactiveColor.toHex(),
      "darkNoteBackgroundColor":  darkTheme.noteBackgroundColor.toHex(),
      "darkNoteTextColor":  darkTheme.noteTextColor.toHex(),
      "darkFloatingButtonBackground":  darkTheme.floatingButtonBackground.toHex(),
      "darkFloatingButtonIconColor":  darkTheme.floatingButtonIconColor.toHex(),
      "darkCheckBoxColor":  darkTheme.checkBoxColor.toHex(),
      "darkCheckBoxCheckColor":  darkTheme.checkBoxCheckColor.toHex(),
    };
  }

}
