
import 'package:amphi/models/app.dart';
import 'package:flutter/material.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';

class ThemeModel {
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color lightGray = Color.fromRGBO(245, 245, 245, 1);
  static const Color black = Color.fromRGBO(0, 0, 0, 1);
  static const Color lightBlue = Color.fromRGBO(0, 140, 255, 1.0);
  static const Color skyBlue = Color.fromRGBO(70, 180, 255, 1.0);
  static const Color midnight = Color.fromRGBO(35, 35, 35, 1.0);
  static const Color inactiveGray = Color(0xFF999999);
  static const Color yellow = Color(0xFFFFF176);
  static const Color charCoal = Color.fromRGBO(45, 45, 45, 1.0);
  static const Color transparent = Color(0x00000000);
  static const Color red = Color(0xFFFF1F24);

  String title = "";
  String id;
  DateTime created = DateTime.now();
  DateTime modified = DateTime.now();

  ThemeColors lightColors = ThemeColors(
      background: lightGray, text: charCoal, accent: lightBlue, card: white, floatingButtonBackground: white, floatingButtonIcon: lightBlue);

  ThemeColors darkColors = ThemeColors(
      background: midnight, text: white, accent: lightBlue, card: charCoal, floatingButtonBackground: white, floatingButtonIcon: lightBlue);

  ThemeModel.fromMap(Map<String, dynamic> data) : id = data["id"] {
    title = data["title"];
      created = DateTime.fromMillisecondsSinceEpoch(data["created"]).toLocal();
      modified = DateTime.fromMillisecondsSinceEpoch(data["modified"]).toLocal();
    lightColors = ThemeColors(
        background: Color(data["background_light"]),
        text: Color(data["text_light"]),
        accent: Color(data["accent_light"]),
        card: Color(data["card_light"]),
        floatingButtonBackground: Color(data["floating_button_background_light"]),
        floatingButtonIcon: Color(data["floating_button_icon_light"])
    );

    darkColors = ThemeColors(
        background: Color(data["background_dark"]),
        text: Color(data["text_dark"]),
        accent: Color(data["accent_dark"]),
        card: Color(data["card_dark"]),
        floatingButtonBackground: Color(data["floating_button_background_dark"]),
        floatingButtonIcon: Color(data["floating_button_icon_dark"])
    );

  }

  ThemeModel({this.title = "", this.id = ""});

  Future<void> save({bool upload = true}) async {
    if(id.isEmpty) {
      return;
    }
    final database = await databaseHelper.database;
    await database.insert("themes", toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    if (upload) {
      appWebChannel.uploadThemeModel(this);
    }
  }

  Future<void> delete({bool upload = true}) async {
    if(id.isEmpty) {
      return;
    }
    final database = await databaseHelper.database;
    await database.delete("themes", where: "id = ?", whereArgs: [id]);

    if (upload) {
      appWebChannel.deleteTheme(this);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "created": created.toUtc().millisecondsSinceEpoch,
      "modified": modified.toUtc().millisecondsSinceEpoch,

      "background_light": lightColors.background.toARGB32(),
      "text_light": lightColors.text.toARGB32(),
      "accent_light": lightColors.accent.toARGB32(),
      "card_light": lightColors.card.toARGB32(),
      "floating_button_background_light": lightColors.floatingButtonBackground.toARGB32(),
      "floating_button_icon_light": lightColors.floatingButtonIcon.toARGB32(),

      "background_dark": lightColors.background.toARGB32(),
      "text_dark": darkColors.text.toARGB32(),
      "accent_dark": darkColors.accent.toARGB32(),
      "card_dark": darkColors.card.toARGB32(),
      "floating_button_background_dark": darkColors.floatingButtonBackground.toARGB32(),
      "floating_button_icon_dark": darkColors.floatingButtonIcon.toARGB32()
    };
  }

  static ThemeModel copy(ThemeModel themeModel) {
    final result = ThemeModel(
      title: themeModel.title,
      id: themeModel.id
    );
    result.lightColors = themeModel.lightColors;
    result.darkColors = themeModel.darkColors;
    return result;
  }


  ThemeData toThemeData({required Brightness brightness, required BuildContext context}) {
    if(brightness == Brightness.light) {
      return _themeData(brightness: brightness, context: context, colors: lightColors);
    }
    else {
      return _themeData(brightness: brightness, context: context, colors: darkColors);
    }
  }

  ThemeData _themeData({required Brightness brightness, required BuildContext context, required ThemeColors colors}) {
    return ThemeData(
      brightness: brightness,
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: ThemeModel.inactiveGray, fontSize: 15),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colors.accent, style: BorderStyle.solid, width: 2)),
          border: UnderlineInputBorder(borderSide: BorderSide(color: colors.background, style: BorderStyle.solid))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: colors.background,
              elevation: 0,
              padding: const EdgeInsets.only(left: 10, right: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              textStyle: TextStyle(color: colors.accent, fontSize: 20, fontWeight: FontWeight.bold))),
      // scrollbarTheme: ScrollbarThemeData(
      //   trackColor: WidgetStateColor.transparent,
      //   thumbColor: WidgetStatePropertyAll(
      //     Colors.red
      //   )
      // ),
      dividerColor: Color.fromARGB(60, 153, 153, 153),
      dropdownMenuTheme: DropdownMenuThemeData(textStyle: TextStyle(color: colors.text, fontSize: 15)),
      popupMenuTheme: PopupMenuThemeData(
        mouseCursor: WidgetStatePropertyAll(SystemMouseCursors.basic),
          surfaceTintColor: colors.background, color: colors.background, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            surfaceTintColor: WidgetStateProperty.all(colors.background),
            mouseCursor: WidgetStateProperty.all(MouseCursor.defer),
          )),
      shadowColor: ((colors.background.g * 255).round() & 0xff) + ((colors.background.b * 255).round() & 0xff) + ((colors.background.r * 255).round() & 0xff) > 381
          ? Colors.grey.withValues(alpha: 0.5)
          : Colors.black.withValues(alpha: 0.5),
      iconTheme: IconThemeData(
          color: App.isWideScreen(context) || App.isDesktop() ? colors.text.soften(brightness) : colors.accent,
          size: App.isWideScreen(context) || App.isDesktop() ? 20 : 15),

      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.card;
          } else {
            return ThemeModel.transparent;
          }
        }),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.accent;
          } else {
            return ThemeModel.transparent;
          }
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      appBarTheme: AppBarTheme(
          backgroundColor: colors.background.withAlpha(245),
          surfaceTintColor: colors.background.withAlpha(245),
          toolbarHeight: 40,
          titleSpacing: 0.0,
          iconTheme: IconThemeData(color: colors.accent, size: App.isDesktop() || App.isWideScreen(context) ? 25 : 20)),
      disabledColor: ThemeModel.inactiveGray,
      highlightColor: colors.accent,
      scaffoldBackgroundColor: colors.background,
      cardColor: colors.card,
      snackBarTheme: SnackBarThemeData(
          backgroundColor: colors.floatingButtonBackground,
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.vertical,
          contentTextStyle: TextStyle(color: colors.floatingButtonIcon)),
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.accent,
        onPrimary: colors.text,
        secondary: colors.accent,
        onSecondary: colors.text,
        onError: colors.accent,
        error: ThemeModel.red,
        surface: colors.card,
        onSurface: colors.text,
      ),
      floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: colors.floatingButtonBackground, focusColor: colors.floatingButtonIcon, iconSize: 35),
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: colors.text, fontSize: 15, overflow: TextOverflow.ellipsis),
      ),
      dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: colors.background,
          surfaceTintColor: colors.background,
          titleTextStyle: TextStyle(color: colors.text, fontSize: 17.5, fontWeight: FontWeight.bold)),
      navigationDrawerTheme: NavigationDrawerThemeData(
          backgroundColor: Color.fromARGB((colors.background.a * 255).round() & 0xff, ((colors.background.r * 255).round() & 0xff) - 10, ((colors.background.g * 255).round() & 0xff) - 10, ((colors.background.b * 255).round() & 0xff) - 10)),
    );
  }
}

class ThemeColors {
  Color background;
  Color text;
  Color accent;
  Color card;
  Color floatingButtonBackground;
  Color floatingButtonIcon;

  ThemeColors({
    required this.background,
    required this.text,
    required this.accent,
    required this.card,
    required this.floatingButtonBackground,
    required this.floatingButtonIcon,
  });
}

const softenValue = 60;

extension SoftenExtension on Color {
  Color soften(Brightness brightness) {
    if(brightness == Brightness.light) {
      return Color.fromARGB((a * 255).round() & 0xff, ((r * 255).round() & 0xff) + softenValue, ((g * 255).round() & 0xff) + softenValue, ((b * 255).round() & 0xff) + softenValue);
    }
    else {
      return Color.fromARGB((a * 255).round() & 0xff, ((r * 255).round() & 0xff) - softenValue, ((g * 255).round() & 0xff) - softenValue, ((b * 255).round() & 0xff) - softenValue);
    }
  }
}