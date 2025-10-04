import 'package:flutter/material.dart';
import 'package:notes/components/settings/color_row.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:notes/models/app_theme.dart';
import 'package:notes/icons/icons.dart';

class EditThemeDialog extends StatefulWidget {
  final AppTheme appTheme;
  final void Function(AppTheme) onSave;

  const EditThemeDialog(
      {super.key, required this.appTheme, required this.onSave});

  @override
  State<EditThemeDialog> createState() => _EditThemeDialogState();
}

class _EditThemeDialogState extends State<EditThemeDialog> {
  late AppTheme appTheme = widget.appTheme;
  AppTheme defaultTheme = AppTheme(created: DateTime.now(), modified: DateTime.now());
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    setState(() {
      textEditingController.text = appTheme.title;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      child: Container(
        width: screenWidth > 400 ? 400 : null,
        height: screenHeight > 600 ? 600 : null,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Positioned(
                left: 0,
                top: 5,
                child: IconButton(
                  icon: const Icon(
                    AppIcons.times,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )),
            Positioned(
                right: 0,
                top: 5,
                child: IconButton(
                  icon: const Icon(
                    AppIcons.check,
                    size: 20,
                  ),
                  onPressed: () {
                    appTheme.title = textEditingController.text;
                    widget.onSave(appTheme);
                    Navigator.pop(context);
                  },
                )),
            Positioned(
                left: 40,
                right: 40,
                top: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .get("@hint_theme_name"))),
                )),
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ColorRow(
                      label: AppLocalizations.of(context)
                          .get("@color_name_background_color"),
                      lightColor: appTheme.lightTheme.backgroundColor,
                      darkColor: appTheme.darkTheme.backgroundColor,
                      defaultLightColor: defaultTheme.lightTheme.backgroundColor,
                      defaultDarkColor: defaultTheme.darkTheme.backgroundColor,
                      lightColorChanged: (Color color) {
                        setState(() {
                          appTheme.lightTheme.backgroundColor = color;
                        });
                      },
                      darkColorChanged: (Color color) {
                        setState(() {
                          appTheme.darkTheme.backgroundColor = color;
                        });
                      },
                    ),
                    ColorRow(
                      label: AppLocalizations.of(context)
                          .get("@color_name_text_color"),
                      lightColor: appTheme.lightTheme.textColor,
                      darkColor: appTheme.darkTheme.textColor,
                                defaultLightColor: defaultTheme.lightTheme.textColor,
                      defaultDarkColor: defaultTheme.darkTheme.textColor,
                      lightColorChanged: (Color color) {
                        setState(() {
                          appTheme.lightTheme.textColor = color;
                        });
                      },
                      darkColorChanged: (Color color) {
                        setState(() {
                          appTheme.darkTheme.textColor = color;
                        });
                      },
                    ),
                    ColorRow(
                      label: AppLocalizations.of(context)
                          .get("@color_name_accent_color"),
                      lightColor: appTheme.lightTheme.accentColor,
                      darkColor: appTheme.darkTheme.accentColor,
                            defaultLightColor: defaultTheme.lightTheme.accentColor,
                      defaultDarkColor: defaultTheme.darkTheme.accentColor,
                      lightColorChanged: (Color color) {
                        setState(() {
                          appTheme.lightTheme.accentColor = color;
                        });
                      },
                      darkColorChanged: (Color color) {
                        setState(() {
                          appTheme.darkTheme.accentColor = color;
                        });
                      },
                    ),
                    ColorRow(
                      label: AppLocalizations.of(context)
                          .get("@color_name_inactive_color"),
                      lightColor: appTheme.lightTheme.inactiveColor,
                      darkColor: appTheme.darkTheme.inactiveColor,
                            defaultLightColor: defaultTheme.lightTheme.inactiveColor,
                      defaultDarkColor: defaultTheme.darkTheme.inactiveColor,
                      lightColorChanged: (Color color) {
                        setState(() {
                          appTheme.lightTheme.inactiveColor = color;
                        });
                      },
                      darkColorChanged: (Color color) {
                        setState(() {
                          appTheme.darkTheme.inactiveColor = color;
                        });
                      },
                    ),
                    ColorRow(
                      label: AppLocalizations.of(context)
                          .get("@color_name_note_background_color"),
                      lightColor: appTheme.lightTheme.noteBackgroundColor,
                      darkColor: appTheme.darkTheme.noteBackgroundColor,
                               defaultLightColor: defaultTheme.lightTheme.noteBackgroundColor,
                      defaultDarkColor: defaultTheme.darkTheme.noteBackgroundColor,
                      lightColorChanged: (Color color) {
                        setState(() {
                          appTheme.lightTheme.noteBackgroundColor = color;
                        });
                      },
                      darkColorChanged: (Color color) {
                        setState(() {
                          appTheme.darkTheme.noteBackgroundColor = color;
                        });
                      },
                    ),
                    ColorRow(
                      label: AppLocalizations.of(context)
                          .get("@color_name_note_text_color"),
                      lightColor: appTheme.lightTheme.noteTextColor,
                      darkColor: appTheme.darkTheme.noteTextColor,
                           defaultLightColor: defaultTheme.lightTheme.noteTextColor,
                      defaultDarkColor: defaultTheme.darkTheme.noteTextColor,
                      lightColorChanged: (Color color) {
                        setState(() {
                          appTheme.lightTheme.noteTextColor = color;
                        });
                      },
                      darkColorChanged: (Color color) {
                        setState(() {
                          appTheme.darkTheme.noteTextColor = color;
                        });
                      },
                    ),
                    ColorRow(
                      label: AppLocalizations.of(context)
                          .get("@color_name_floating_button_background"),
                      lightColor: appTheme.lightTheme.floatingButtonBackground,
                      darkColor: appTheme.darkTheme.floatingButtonBackground,
                         defaultLightColor: defaultTheme.lightTheme.floatingButtonBackground,
                      defaultDarkColor: defaultTheme.darkTheme.floatingButtonBackground,
                      lightColorChanged: (Color color) {
                        setState(() {
                          appTheme.lightTheme.floatingButtonBackground = color;
                        });
                      },
                      darkColorChanged: (Color color) {
                        setState(() {
                          appTheme.darkTheme.floatingButtonBackground = color;
                        });
                      },
                    ),
                    ColorRow(
                      label: AppLocalizations.of(context)
                          .get("@color_name_floating_button_icon_color"),
                      lightColor: appTheme.lightTheme.floatingButtonIconColor,
                      darkColor: appTheme.darkTheme.floatingButtonIconColor,
                                               defaultLightColor: defaultTheme.lightTheme.floatingButtonIconColor,
                      defaultDarkColor: defaultTheme.darkTheme.floatingButtonIconColor,
                      lightColorChanged: (Color color) {
                        setState(() {
                          appTheme.lightTheme.floatingButtonIconColor = color;
                        });
                      },
                      darkColorChanged: (Color color) {
                        setState(() {
                          appTheme.darkTheme.floatingButtonIconColor = color;
                        });
                      },
                    ),
                    ColorRow(
                      label: AppLocalizations.of(context)
                          .get("@color_name_check_box_color"),
                      lightColor: appTheme.lightTheme.checkBoxColor,
                      darkColor: appTheme.darkTheme.checkBoxColor,
                                      defaultLightColor: defaultTheme.lightTheme.checkBoxColor,
                      defaultDarkColor: defaultTheme.darkTheme.checkBoxColor,
                      lightColorChanged: (Color color) {
                        setState(() {
                          appTheme.lightTheme.checkBoxColor = color;
                        });
                      },
                      darkColorChanged: (Color color) {
                        setState(() {
                          appTheme.darkTheme.checkBoxColor = color;
                        });
                      },
                    ),
                    ColorRow(
                      label: AppLocalizations.of(context)
                          .get("@color_name_check_box_check_color"),
                      lightColor: appTheme.lightTheme.checkBoxCheckColor,
                      darkColor: appTheme.darkTheme.checkBoxCheckColor,
                                   defaultLightColor: defaultTheme.lightTheme.checkBoxCheckColor,
                      defaultDarkColor: defaultTheme.darkTheme.checkBoxCheckColor,
                      lightColorChanged: (Color color) {
                        setState(() {
                          appTheme.lightTheme.checkBoxCheckColor = color;
                        });
                      },
                      darkColorChanged: (Color color) {
                        setState(() {
                          appTheme.darkTheme.checkBoxCheckColor = color;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
