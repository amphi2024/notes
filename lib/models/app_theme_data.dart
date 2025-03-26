import 'package:flutter/material.dart';
import 'package:amphi/models/app.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_theme.dart';

class AppThemeData {
  Color backgroundColor;
  Color textColor;
  Color accentColor;
  Color inactiveColor;
  Color noteBackgroundColor;
  Color noteTextColor;
  Color floatingButtonBackground;
  Color floatingButtonIconColor;
  Color checkBoxColor;
  Color checkBoxCheckColor;
  Color errorColor;

  AppThemeData({
    this.backgroundColor = AppTheme.midnight,
    this.textColor = AppTheme.white,
    this.accentColor = AppTheme.lightBlue,
    this.inactiveColor = AppTheme.inactiveGray,
    this.noteBackgroundColor = AppTheme.charCoal,
    this.noteTextColor = AppTheme.white,
    this.floatingButtonBackground = AppTheme.white,
    this.floatingButtonIconColor = AppTheme.lightBlue,
    this.checkBoxColor = AppTheme.lightBlue,
    this.checkBoxCheckColor = AppTheme.white,
    this.errorColor = AppTheme.red
  });

  ThemeData themeData({required Brightness brightness, required BuildContext context}) {
    return ThemeData(
      brightness: brightness,
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: inactiveColor, fontSize: 15),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: accentColor, style: BorderStyle.solid, width: 2)),
          border: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: backgroundColor, style: BorderStyle.solid))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              elevation: 0,
              padding: const EdgeInsets.only(left: 10, right: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              textStyle: TextStyle(
                  color: accentColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold))),
      // scrollbarTheme: ScrollbarThemeData(
      //   trackColor: WidgetStateColor.transparent,
      //   thumbColor: WidgetStatePropertyAll(
      //     Colors.red
      //   )
      // ),
      dividerColor: inactiveColor,
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: TextStyle(
          color: textColor, fontSize: 15
        )
      ),
      popupMenuTheme: PopupMenuThemeData(
        surfaceTintColor: backgroundColor,
        color: backgroundColor,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(10)
       )
      ),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
              surfaceTintColor: WidgetStateProperty.all(backgroundColor))),
      shadowColor:
          backgroundColor.green + backgroundColor.blue + backgroundColor.red >
                  381
              ? Colors.grey.withValues(alpha: 0.5)
              : Colors.black.withValues(alpha: 0.5),
      iconTheme: IconThemeData(color: accentColor, size: App.isWideScreen(context) || App.isDesktop() ? 25 : 15),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return checkBoxCheckColor;
          } else {
            return AppTheme.transparent;
          }
        }),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return checkBoxColor;
          } else {
            return AppTheme.transparent;
          }
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      appBarTheme: AppBarTheme(
          backgroundColor: backgroundColor.withAlpha(245),
          surfaceTintColor: backgroundColor.withAlpha(245),
          toolbarHeight: 40,
          titleSpacing: 0.0,
          iconTheme: IconThemeData(color: accentColor, size: 20)),
      disabledColor: inactiveColor,
      highlightColor: accentColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: noteBackgroundColor,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: floatingButtonBackground,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.vertical,
        contentTextStyle: TextStyle(
          color: floatingButtonIconColor
        )
      ),
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: accentColor,
        onPrimary: textColor,
        secondary: accentColor,
        onSecondary: textColor,
        onError: accentColor,
        error: AppTheme.red,
        surface: noteBackgroundColor,
        onSurface: noteTextColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: floatingButtonBackground,
          focusColor: floatingButtonIconColor,
          iconSize: 35),
      textTheme: TextTheme(
        bodyMedium: TextStyle(
            color: textColor, fontSize: 15, overflow: TextOverflow.ellipsis),
      ),
      dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: backgroundColor,
          surfaceTintColor: backgroundColor,
          titleTextStyle: TextStyle(
              color: textColor, fontSize: 17.5, fontWeight: FontWeight.bold)),
      navigationDrawerTheme: NavigationDrawerThemeData(
          backgroundColor: Color.fromARGB(
              backgroundColor.alpha,
              backgroundColor.red - 10,
              backgroundColor.green - 10,
              backgroundColor.blue - 10)),
    );
  }
}

extension ThemeDataExtension on ThemeData {

  ThemeData noteThemeData() {
    Color noteBackgroundColor = brightness == Brightness.light
        ? appSettings.appTheme!.lightTheme.noteBackgroundColor
        : appSettings.appTheme!.darkTheme.noteBackgroundColor;
    Color noteTextColor = brightness == Brightness.light
        ? appSettings.appTheme!.lightTheme.noteTextColor
        : appSettings.appTheme!.darkTheme.noteTextColor;

    return copyWith(
        scaffoldBackgroundColor: noteBackgroundColor,
        textTheme: TextTheme(
            bodyMedium: TextStyle(color: noteTextColor, fontSize: 15),
            bodyLarge: TextStyle(color: noteTextColor, fontSize: 15)
        ),
        appBarTheme: AppBarTheme(
            backgroundColor: noteBackgroundColor,
            surfaceTintColor: noteBackgroundColor,
            toolbarHeight: 40,
            titleSpacing: 0.0,
            iconTheme: IconThemeData(
                color: brightness == Brightness.light
                    ? appSettings.appTheme!.lightTheme.accentColor
                    : appSettings.appTheme!.darkTheme.accentColor,
                size: 30)),
        iconTheme: IconThemeData(
            color: iconTheme.color,
            size: 30
        ),
    );
  }
}
