import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/settings/color_row.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:notes/models/theme_model.dart';
import 'package:notes/providers/themes_provider.dart';

class EditThemeDialog extends ConsumerStatefulWidget {
  final ThemeModel themeModel;
  final bool showDeleteButton;

  const EditThemeDialog({super.key, required this.themeModel, this.showDeleteButton = false});

  @override
  ConsumerState<EditThemeDialog> createState() => _EditThemeDialogState();
}

class _EditThemeDialogState extends ConsumerState<EditThemeDialog> {
  late ThemeModel themeModel = ThemeModel.copy(widget.themeModel);
  ThemeModel defaultTheme = ThemeModel(created: DateTime.now(), modified: DateTime.now());
  late TextEditingController textEditingController = TextEditingController(text: themeModel.title);

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Dialog(
      child: SizedBox(
        width: screenWidth > 400 ? 400 : null,
        height: screenHeight > 375 ? 375 : null,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.cancel_outlined,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)
                                .get("@hint_theme_name"))),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.check_circle_outline,
                    size: 20,
                  ),
                  onPressed: () {
                    themeModel.title = textEditingController.text;
                    themeModel.save();
                    ref.read(themesProvider.notifier).insertTheme(themeModel);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  ColorRow(
                    label: AppLocalizations.of(context)
                        .get("@color_name_background_color"),
                    lightColor: themeModel.lightColors.background,
                    darkColor: themeModel.darkColors.background,
                    defaultLightColor: defaultTheme.lightColors.background,
                    defaultDarkColor: defaultTheme.darkColors.background,
                    lightColorChanged: (Color color) {
                      setState(() {
                        themeModel.lightColors.background = color;
                      });
                    },
                    darkColorChanged: (Color color) {
                      setState(() {
                        themeModel.darkColors.background = color;
                      });
                    },
                  ),
                  ColorRow(
                    label: AppLocalizations.of(context)
                        .get("@color_name_text_color"),
                    lightColor: themeModel.lightColors.text,
                    darkColor: themeModel.darkColors.text,
                    defaultLightColor: defaultTheme.lightColors.text,
                    defaultDarkColor: defaultTheme.darkColors.text,
                    lightColorChanged: (Color color) {
                      setState(() {
                        themeModel.lightColors.text = color;
                      });
                    },
                    darkColorChanged: (Color color) {
                      setState(() {
                        themeModel.darkColors.text = color;
                      });
                    },
                  ),
                  ColorRow(
                    label: AppLocalizations.of(context)
                        .get("@color_name_accent_color"),
                    lightColor: themeModel.lightColors.accent,
                    darkColor: themeModel.darkColors.accent,
                    defaultLightColor: defaultTheme.lightColors.accent,
                    defaultDarkColor: defaultTheme.darkColors.accent,
                    lightColorChanged: (Color color) {
                      setState(() {
                        themeModel.lightColors.accent = color;
                      });
                    },
                    darkColorChanged: (Color color) {
                      setState(() {
                        themeModel.darkColors.accent = color;
                      });
                    },
                  ),
                  ColorRow(
                    label: AppLocalizations.of(context)
                        .get("@color_name_note_background_color"),
                    lightColor: themeModel.lightColors.card,
                    darkColor: themeModel.darkColors.card,
                    defaultLightColor: defaultTheme.lightColors.card,
                    defaultDarkColor: defaultTheme.darkColors.card,
                    lightColorChanged: (Color color) {
                      setState(() {
                        themeModel.lightColors.card = color;
                      });
                    },
                    darkColorChanged: (Color color) {
                      setState(() {
                        themeModel.darkColors.card = color;
                      });
                    },
                  ),
                  ColorRow(
                    label: AppLocalizations.of(context)
                        .get("@color_name_floating_button_background"),
                    lightColor: themeModel.lightColors.floatingButtonBackground,
                    darkColor: themeModel.darkColors.floatingButtonBackground,
                    defaultLightColor: defaultTheme.lightColors.floatingButtonBackground,
                    defaultDarkColor: defaultTheme.darkColors.floatingButtonBackground,
                    lightColorChanged: (Color color) {
                      setState(() {
                        themeModel.lightColors.floatingButtonBackground = color;
                      });
                    },
                    darkColorChanged: (Color color) {
                      setState(() {
                        themeModel.darkColors.floatingButtonBackground = color;
                      });
                    },
                  ),
                  ColorRow(
                    label: AppLocalizations.of(context)
                        .get("@color_name_floating_button_icon_color"),
                    lightColor: themeModel.lightColors.floatingButtonIcon,
                    darkColor: themeModel.darkColors.floatingButtonIcon,
                    defaultLightColor: defaultTheme.lightColors.floatingButtonIcon,
                    defaultDarkColor: defaultTheme.darkColors.floatingButtonIcon,
                    lightColorChanged: (Color color) {
                      setState(() {
                        themeModel.lightColors.floatingButtonIcon = color;
                      });
                    },
                    darkColorChanged: (Color color) {
                      setState(() {
                        themeModel.darkColors.floatingButtonIcon = color;
                      });
                    },
                  ),
                ],
              ),
            ),
            if(widget.showDeleteButton) ...[
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                    ),
                    onPressed: () {
                      showDialog(context: context, builder: (ctx) {
                        return ConfirmationDialog(title: AppLocalizations.of(ctx).get("@dialog_title_delete_theme"), onConfirmed: () {
                          themeModel.delete();
                          ref.read(themesProvider.notifier).deleteTheme(themeModel.id);
                          Navigator.pop(context);
                        });
                      });
                    },
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }
}
