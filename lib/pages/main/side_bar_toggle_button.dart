import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/providers/providers.dart';

import '../../channels/app_method_channel.dart';
import '../../models/app_settings.dart';
import '../../icons/icons.dart';

class SideBarToggleButton extends ConsumerStatefulWidget {

  const SideBarToggleButton({super.key});

  @override
  ConsumerState<SideBarToggleButton> createState() => _SideBarToggleButtonState();
}

class _SideBarToggleButtonState extends ConsumerState<SideBarToggleButton> {

  bool isFullscreen = false;

  @override
  void dispose() {
    appMethodChannel.fullScreenListeners.remove(fullScreenListener);
    super.dispose();
  }

  void fullScreenListener(bool fullScreen) {
    setState(() {
      isFullscreen = fullScreen;
    });
  }

  @override
  void initState() {
    appMethodChannel.fullScreenListeners.add(fullScreenListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double left = 5;
    double top = 7.5;

    if (Platform.isMacOS) {
      left = isFullscreen ? 5 : 80;
    }

    if (!appSettings.dockedFloatingMenu && appSettings.floatingMenuShowing) {
      left = 20;
      top = 20;
      if (Platform.isMacOS && !isFullscreen) {
        top = 30;
      }
    }

    if (Platform.isAndroid) {
      top += MediaQuery
          .of(context)
          .padding
          .top;
    }

    return AnimatedPositioned(
        left: left,
        top: top,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
        child: GestureDetector(
          onLongPress: () {
            // if (appSettings.floatingMenuShowing) {
            //   ref.read(wideMainPageStateProvider.notifier).setsid
            //   widget.setState(() {
            //     appSettings.dockedFloatingMenu =
            //     !appSettings.dockedFloatingMenu;
            //   });
            //   appSettings.save();
            // }
          },
          child: IconButton(
              icon: Icon(AppIcons.sidebar, size: Theme.of(context).appBarTheme.iconTheme?.size),
              onPressed: () {
                ref.read(wideMainPageStateProvider.notifier).setSideBarShowing(!ref.watch(wideMainPageStateProvider).sideBarShowing);
              }),
        ));
  }
}
