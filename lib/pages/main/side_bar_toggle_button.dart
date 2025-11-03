import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/models/app_cache_data.dart';
import 'package:notes/providers/providers.dart';

import '../../channels/app_method_channel.dart';
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
    final wideMainPageState = ref.watch(wideMainPageStateProvider);
    double left = 0;
    double top = 0;

    if (Platform.isMacOS) {
      left = isFullscreen ? 5 : 80;
    }

    if (wideMainPageState.sideBarFloating && wideMainPageState.sideBarShowing) {
      left = 20;
      top = 30;
    }

    top += MediaQuery.of(context).padding.top;

    return AnimatedPositioned(
        left: left,
        top: top,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
        child: GestureDetector(
          onLongPress: () {
            appCacheData.sidebarFloating = !wideMainPageState.sideBarFloating;
            appCacheData.save();
            ref.read(wideMainPageStateProvider.notifier).setSideBarFloating(!wideMainPageState.sideBarFloating);
          },
          child: SizedBox(
            width: 55,
            height: 55,
            child: Center(
              child: IconButton(
                  icon: Icon(AppIcons.sidebar, size: Theme.of(context).appBarTheme.iconTheme?.size),
                  onPressed: () {
                    ref.read(wideMainPageStateProvider.notifier).setSideBarShowing(!ref.watch(wideMainPageStateProvider).sideBarShowing);
                  }),
            ),
          ),
        ));
  }
}
