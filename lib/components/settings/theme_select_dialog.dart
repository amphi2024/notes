import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/channels/app_web_delete.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:notes/components/settings/edit_theme_dialog.dart';
import 'package:notes/components/settings/theme_item.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/app_theme.dart';
import 'package:notes/models/icons.dart';

class ThemeSelectDialog extends StatefulWidget {

  final List<AppTheme> themeList;
  const ThemeSelectDialog({super.key, required this.themeList});

  @override
  State<ThemeSelectDialog> createState() => _ThemeSelectDialogState();
}

class _ThemeSelectDialogState extends State<ThemeSelectDialog> {


  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 375,
        height: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  icon: Icon( AppIcons.times), onPressed: () {
                Navigator.pop(context);
              }),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: widget.themeList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns in the grid
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0, // Spacing between rows
                ),
                itemBuilder: (context, index) {
                return SizedBox(
                  height: 200,
                  child: Listener(
                    onPointerDown: (event) {
                      if(event.kind == PointerDeviceKind.mouse && event.buttons == kSecondaryMouseButton) {

                      }
                    },
                    onPointerHover: (event) {

                    },
                     child: ThemeItem(
                                   appTheme: widget.themeList[index],
                                   onLongPressed: () {

                                   },
                                   onButtonPressed: () {

                                     showDialog(context: context, builder: (context) {
                                         return ConfirmationDialog(title: AppLocalizations.of(context).get("@dialog_title_delete_theme"), onConfirmed: () {
                                           widget.themeList[index].delete();
                                           appWebChannel.deleteTheme(appTheme: widget.themeList[index]);
                                           setState(() {
                                             widget.themeList.removeAt(index);
                                           });
                                         });
                                     });

                                   },
                                   onBelowButtonPressed: () {
                                    showDialog(context: context, builder: (context) {
                                      return EditThemeDialog(appTheme: widget.themeList[index],
                                        onSave: (AppTheme appTheme) {
                                          setState(() {
                                            widget.themeList[index] = appTheme;
                                          });
                                          appTheme.save();
                                        });
                                    });
                                   },
                                  eventAllowed: index > 0,
                                   onTap: () {
                                     appState.notifySomethingChanged(() {
                                       appSettings.appTheme = widget.themeList[index];
                                     });
                                   Navigator.pop(context);
                                 })),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}