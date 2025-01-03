import 'package:amphi/extensions/color_extension.dart';
import 'package:flutter/material.dart';

abstract class Item {
  String title;
  String filename;
  String path;
  String location;

  DateTime created;
  DateTime modified;
  DateTime originalCreated;
  DateTime originalModified;
  DateTime? deleted;

  Color? backgroundColor;
  Color? textColor;
  bool editedModified = false;
  bool editedCreated = false;

  Item({
    required this.filename,
    required this.path,
    required this.location,
    required this.created,
    required this.originalCreated,
    required this.modified,
    required this.originalModified,
    this.deleted,
    this.title = "",
    this.textColor,
    this.backgroundColor
  });

  Color? textColorByTheme(bool darkMode) {
    return darkMode ? textColor?.inverted() : textColor;
  }

  Color? backgroundColorByTheme(bool darkMode) {
    return darkMode ? backgroundColor?.inverted() : backgroundColor;
  }

}

extension DarkModeTheme on ThemeData {
  bool isDarkMode() {
    return brightness == Brightness.dark;
  }
}