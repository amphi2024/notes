import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import '../../models/app_settings.dart';
import '../../models/icons.dart';

class SideBarToggleButton extends StatelessWidget {

  final void Function(void Function()) setState;
  const SideBarToggleButton({super.key, required this.setState});

  @override
  Widget build(BuildContext context) {
    double left = 5;
    double top = 10;

    if(Platform.isMacOS && !appWindow.isMaximized) {
      left = 60;
      //top = 20;
    }

    if(!appSettings.dockedFloatingMenu && appSettings.floatingMenuShowing) {
      left = 20;
      if(Platform.isMacOS && !appWindow.isMaximized) {
        left = 70;
      }
      top = 20;
    }

    return AnimatedPositioned(
        left: left,
        top: top,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
        child: GestureDetector(
          onLongPress: () {
            if (appSettings.floatingMenuShowing) {
              setState(() {
                appSettings.dockedFloatingMenu =
                !appSettings.dockedFloatingMenu;
              });
              appSettings.save();
            }
          },
          child: IconButton(
              icon: Icon(AppIcons.sidebar),
              onPressed: () {
                setState(() {
                  appSettings.floatingMenuShowing = !appSettings.floatingMenuShowing;
                });
                appSettings.save();
              }),
        ));
  }
}
