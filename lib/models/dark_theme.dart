import 'package:flutter/material.dart';
import 'package:notes/models/app_theme.dart';
import 'package:notes/models/app_theme_data.dart';

class DarkTheme extends AppThemeData {

  DarkTheme(
      {
        super.backgroundColor = AppTheme.midnight,
        super.textColor = AppTheme.white,
        super.accentColor = AppTheme.lightBlue,
        super.inactiveColor = AppTheme.inactiveGray,
        super.noteBackgroundColor = AppTheme.charCoal,
        super.noteTextColor = AppTheme.white,
        super.floatingButtonBackground = AppTheme.white,
        super.floatingButtonIconColor = AppTheme.lightBlue,
        super.checkBoxColor = AppTheme.lightBlue,
        super.checkBoxCheckColor = AppTheme.white,
        super.errorColor = AppTheme.red
      });

  ThemeData toThemeData(BuildContext context) {
    return themeData(
      brightness: Brightness.dark, context: context);
  }
}