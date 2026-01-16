import 'package:flutter/widgets.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:modern_titlebar_buttons/modern_titlebar_buttons.dart';
import 'package:notes/models/app_settings.dart';
import 'package:window_manager/window_manager.dart';

const _iconSize = 23.0;

List<Widget> customWindowButtons() {
  if (appSettings.windowButtonsOnLeft) {
    switch (appSettings.windowControlsStyle) {
      case "arc":
        return [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.arc,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
          DecoratedMinimizeButton(
              type: ThemeType.arc,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.arc,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
        ];
      case "breeze":
        return [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.breeze,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
          DecoratedMinimizeButton(
              type: ThemeType.breeze,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.breeze,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
        ];
      case "elementary":
        return [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.elementary,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
          DecoratedMinimizeButton(
              type: ThemeType.elementary,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.elementary,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
        ];
      case "flatRemix":
        return [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.flatRemix,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
          DecoratedMinimizeButton(
              type: ThemeType.flatRemix,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.flatRemix,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
        ];
      case "materia":
        return [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.materia,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
          DecoratedMinimizeButton(
              type: ThemeType.materia,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.materia,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
        ];
      case "nordic":
        return [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.nordic,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
          DecoratedMinimizeButton(
              type: ThemeType.nordic,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.nordic,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
        ];
      case "pop":
        return [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.pop,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
          DecoratedMinimizeButton(
              type: ThemeType.pop,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.pop,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
        ];
      case "unity":
        return [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.unity,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
          DecoratedMinimizeButton(
              type: ThemeType.unity,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.unity,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
        ];
      case "vimix":
        return [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.vimix,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
          DecoratedMinimizeButton(
              type: ThemeType.vimix,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.vimix,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
        ];
      case "yaru":
        return [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.yaru,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
          DecoratedMinimizeButton(
              type: ThemeType.yaru,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.yaru,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
        ];
      case "osxarc":
        return [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.osxArc,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
          DecoratedMinimizeButton(
              type: ThemeType.osxArc,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.osxArc,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
        ];
      default:
        return [
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: AdwWindowButton(
                buttonType: WindowButtonType.close,
                onPressed: () => _close(),
                nativeControls: false),
          ),
          AdwWindowButton(
              buttonType: WindowButtonType.minimize,
              onPressed: () => _minimize(),
              nativeControls: false),
          AdwWindowButton(
              buttonType: WindowButtonType.maximize,
              onPressed: () => _maximizeOrRestore(),
              nativeControls: false),
        ];
    }
  }
    switch (appSettings.windowControlsStyle) {
      
      case "arc":
        return [
          DecoratedMinimizeButton(
              type: ThemeType.arc,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.arc,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
                      Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.arc,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
        ];
      case "breeze":
        return [
          DecoratedMinimizeButton(
              type: ThemeType.breeze,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.breeze,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.breeze,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
        ];
      case "elementary":
        return [
          DecoratedMinimizeButton(
              type: ThemeType.elementary,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.elementary,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.elementary,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
        ];
      case "flatRemix":
        return [
          DecoratedMinimizeButton(
              type: ThemeType.flatRemix,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.flatRemix,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.flatRemix,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
        ];
      case "materia":
        return [
          DecoratedMinimizeButton(
              type: ThemeType.materia,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.materia,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.materia,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
        ];
      case "nordic":
        return [
          DecoratedMinimizeButton(
              type: ThemeType.nordic,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.nordic,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.nordic,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
        ];
      case "pop":
        return [
          DecoratedMinimizeButton(
              type: ThemeType.pop,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.pop,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.pop,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
        ];
      case "unity":
        return [
          DecoratedMinimizeButton(
              type: ThemeType.unity,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.unity,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.unity,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
        ];
      case "vimix":
        return [
          DecoratedMinimizeButton(
              type: ThemeType.vimix,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.vimix,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.vimix,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
        ];
      case "yaru":
        return [
          DecoratedMinimizeButton(
              type: ThemeType.yaru,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.yaru,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.yaru,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
        ];
      case "osxarc":
        return [
          DecoratedMinimizeButton(
              type: ThemeType.osxArc,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _minimize()),
          DecoratedMaximizeButton(
              type: ThemeType.osxArc,
              width: _iconSize,
              height: _iconSize,
              onPressed: () => _maximizeOrRestore()),
                        Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: DecoratedCloseButton(
                type: ThemeType.osxArc,
                width: _iconSize,
                height: _iconSize,
                onPressed: () => _close()),
          ),
        ];
      default:
        return [
          AdwWindowButton(
              buttonType: WindowButtonType.minimize,
              onPressed: () => _minimize(),
              nativeControls: false),
          AdwWindowButton(
              buttonType: WindowButtonType.maximize,
              onPressed: () => _maximizeOrRestore(),
              nativeControls: false),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: AdwWindowButton(
                buttonType: WindowButtonType.close,
                onPressed: () => _close(),
                nativeControls: false),
          )
        ];
    }
}

void _minimize() {
  windowManager.minimize();
}

void _maximizeOrRestore() async {
  if (await windowManager.isMaximized()) {
    windowManager.unmaximize();
  } else {
    windowManager.maximize();
  }
}

void _close() {
  windowManager.close();
}
