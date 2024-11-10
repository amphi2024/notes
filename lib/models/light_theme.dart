import 'package:flutter/material.dart';
import 'package:notes/models/app_theme.dart';
import 'package:notes/models/app_theme_data.dart';

class LightTheme extends AppThemeData {

  LightTheme(
      {
        super.backgroundColor = AppTheme.lightGray,
        super.textColor = AppTheme.midnight,
        super.accentColor = AppTheme.lightBlue,
        super.inactiveColor = AppTheme.inactiveGray,
        super.noteBackgroundColor = AppTheme.white,
        super.noteTextColor = AppTheme.midnight,
        super.floatingButtonBackground = AppTheme.white,
        super.floatingButtonIconColor = AppTheme.lightBlue,
        super.checkBoxColor = AppTheme.lightBlue,
        super.checkBoxCheckColor = AppTheme.white,
        super.errorColor = AppTheme.red
      });
  ThemeData toThemeData(BuildContext context) {
    return themeData(
        brightness: Brightness.light, context: context);
  }
}