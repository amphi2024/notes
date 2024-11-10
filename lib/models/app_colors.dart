import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:notes/models/app_storage.dart';
import 'package:amphi/models/app_colors_core.dart';

final appColors = AppColors.getInstance();

class AppColors extends AppColorsCore {
  static final AppColors _instance = AppColors._internal();

  AppColors._internal();

  static AppColors getInstance() => _instance;

  void getData() async {
    File file = File(
        "${appStorage.selectedUser.storagePath}/colors.json");

    if (!file.existsSync()) {
      themeColors = [];
      noteTextColors = [];
      noteBackgroundColors = [];
    } else {
      Map<String, dynamic> map = jsonDecode(await file.readAsString());
      themeColors = decodedColorList(map["themeColors"]);
      noteTextColors = decodedColorList(map["noteTextColors"]);
      noteBackgroundColors = decodedColorList(map["noteBackgroundColors"]);
    }
  }

  late List<Color> noteTextColors;
  late List<Color> noteBackgroundColors;

  Future<void> save() async {
    File file = File(
        "${appStorage.selectedUser.storagePath}/colors.json");
    file.writeAsString(jsonEncode(toMap()));
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "themeColors": encodedColorList(themeColors),
      "noteTextColors": encodedColorList(noteTextColors),
      "noteBackgroundColors": encodedColorList(noteBackgroundColors)
    };
  }
}
