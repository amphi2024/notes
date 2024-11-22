import 'dart:io';

import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/channels/app_web_delete.dart';
import 'package:notes/components/settings/edit_theme_dialog.dart';
import 'package:notes/components/settings/new_theme_item.dart';
import 'package:notes/components/settings/theme_item.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_theme.dart';

class AppThemePageView extends StatefulWidget {
  final void Function(AppTheme appTheme) onPageChanged;
  final List<AppTheme> themeList;
  const AppThemePageView({super.key, required this.onPageChanged, required this.themeList});

  @override
  State<AppThemePageView> createState() => _AppThemePageViewState();
}

class _AppThemePageViewState extends State<AppThemePageView> {
  late List<AppTheme> themeList = widget.themeList;
  late PageController pageController;

  @override
  void initState() {
    if (appSettings.appTheme!.filename != "!DEFAULT") {
      for (int i = 0; i < widget.themeList.length; i++) {
        if (widget.themeList[i].filename == appSettings.appTheme!.filename) {
          pageController = PageController(initialPage: i);
          break;
        }
      }
    } else {
      pageController = PageController(initialPage: 0);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context).get("@theme"),
        ),
        Row(
          children: [
            Visibility(
                visible: Platform.isLinux || Platform.isMacOS || Platform.isWindows,
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_circle_left,
                      size: 40,
                    ),
                    onPressed: () {
                      setState(() {
                        pageController.animateToPage(pageController.page!.round() - 1,
                            duration: Duration(milliseconds: 750), curve: Curves.easeOutQuint);
                      });
                    })),
            SizedBox(
              width: 150,
              height: 160,
              child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (int index) {
                    if (index < themeList.length) {
                      widget.onPageChanged(themeList[index]);
                    }
                  },
                  itemCount: themeList.length + 1,
                  itemBuilder: (context, index) {
                    if (index == themeList.length) {
                      return NewThemeItem(
                        onSave: (appTheme) {
                          appTheme.save();
                        },
                      );
                    } else {
                      return ThemeItem(
                        appTheme: themeList[index],
                        onLongPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return ConfirmationDialog(
                                    title: AppLocalizations.of(context).get("@dialog_title_delete_theme"),
                                    onConfirmed: () {
                                      themeList[index].delete();
                                      appWebChannel.deleteTheme(appTheme: themeList[index]);
                                      setState(() {
                                        themeList.removeAt(index);
                                        pageController.animateToPage(pageController.page!.round() - 1,
                                            duration: Duration(milliseconds: 750), curve: Curves.easeOutQuint);
                                      });
                                    });
                              });
                        },
                        onButtonPressed: () {},
                        onTap: () {
                          if (index > 0) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return EditThemeDialog(
                                      appTheme: themeList[index],
                                      onSave: (AppTheme appTheme) {
                                        setState(() {
                                          themeList[index] = appTheme;
                                        });
                                        appTheme.save();
                                      });
                                });
                          }
                        },
                      );
                    }
                  }),
            ),
            Visibility(
                visible: Platform.isLinux || Platform.isMacOS || Platform.isWindows,
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_circle_right,
                      size: 40,
                    ),
                    onPressed: () {
                      setState(() {
                        pageController.animateToPage(pageController.page!.round() + 1,
                            duration: Duration(milliseconds: 750), curve: Curves.easeOutQuint);
                      });
                    })),
          ],
        )
      ],
    );
  }
}
