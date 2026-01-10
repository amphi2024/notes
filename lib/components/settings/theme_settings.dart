import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/settings/create_theme_button.dart';
import 'package:notes/components/settings/edit_theme_dialog.dart';
import 'package:notes/components/settings/select_theme_dialog.dart';
import 'package:notes/components/settings/theme_item.dart';
import 'package:notes/main.dart';
import 'package:notes/models/theme_model.dart';
import 'package:notes/providers/themes_provider.dart';
import 'package:notes/utils/screen_size.dart';

import '../../models/app_settings.dart';

class ThemeSettings extends StatelessWidget {
  const ThemeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    if (isDesktopOrTablet(context)) {
      return _WideSettings();
    }
    return _MobileSettings();
  }
}

class _WideSettings extends ConsumerStatefulWidget {
  const _WideSettings();

  @override
  ConsumerState createState() => __WideSettingsState();
}

class __WideSettingsState extends ConsumerState<_WideSettings> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(context: context, builder: (context) {
          return SelectThemeDialog();
        });
      },
      child: ThemeItem(id: appSettings.themeModel.id, brightness: Theme.brightnessOf(context)),
    );
  }
}

class _MobileSettings extends ConsumerStatefulWidget {
  const _MobileSettings();

  @override
  ConsumerState createState() => __MobileSettingsState();
}

class __MobileSettingsState extends ConsumerState<_MobileSettings> {
  late Brightness brightness = Theme.of(context).brightness;
  final pageController = PageController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themesState = ref.watch(themesProvider);
      for (var i = 0; i < themesState.idList.length; i++) {
        final id = themesState.idList[i];
        if (id == appSettings.themeModel.id) {
          pageController.jumpToPage(i + 1);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final idList = ref
        .watch(themesProvider)
        .idList;

    return SizedBox(
      width: 150,
      height: 160,
      child: PageView.builder(
          controller: pageController,
          onPageChanged: (int index) {
            if (index == 0) {
              mainScreenKey.currentState?.setState(() {
                appSettings.themeModel = ThemeModel();
              });
            }
            else if (index < idList.length + 1) {
              mainScreenKey.currentState?.setState(() {
                appSettings.themeModel = ref.watch(themesProvider).findThemeByIndex(index - 1);
              });
            }
          },
          itemCount: idList.length + 2,
          itemBuilder: (context, index) {
            if (index == idList.length + 1) {
              return CreateThemeButton();
            } else if (index == 0) {
              return ThemeItem(id: "", brightness: brightness);
            }
            else {
              return GestureDetector(
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                    return EditThemeDialog(
                        showDeleteButton: true,
                        themeModel: ref.watch(themesProvider).findThemeByIndex(index - 1));
                  });
                },
                child: ThemeItem(
                    id: idList[index - 1],
                    brightness: brightness
                ),
              );
            }
          }),
    );
  }
}