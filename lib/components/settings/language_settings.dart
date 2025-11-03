import 'package:amphi/models/app.dart';
import 'package:amphi/widgets/settings/language.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/app_settings.dart';

class LanguageSettings extends StatefulWidget {
  const LanguageSettings({super.key});

  @override
  State<LanguageSettings> createState() => _LanguageSettingsState();
}

class _LanguageSettingsState extends State<LanguageSettings> {
  @override
  Widget build(BuildContext context) {
    if(App.isWideScreen(context) || App.isDesktop()) {
      return _WideSettings();
    }
    return _MobileSettings();
  }
}

class _WideSettings extends StatefulWidget {
  const _WideSettings();

  @override
  State<_WideSettings> createState() => _WideSettingsState();
}

class _WideSettingsState extends State<_WideSettings> {

  late final languages = Language.items(context);
  late List<DropdownMenuItem<Locale?>> languageDropdownItems = Language.dropdownItems(context);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<Locale?>(
          value: appSettings.locale,
          items: languageDropdownItems,
          onChanged: (item) {
            mainScreenKey.currentState?.setState(() {
              appSettings.locale = item;
            });
          }),
    );
  }
}


class _MobileSettings extends StatefulWidget {
  const _MobileSettings();

  @override
  State<_MobileSettings> createState() => _MobileSettingsState();
}

class _MobileSettingsState extends State<_MobileSettings> {

  late final languages = Language.items(context);
  late final FixedExtentScrollController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    int languageIndex = 0;
    if (appSettings.locale != null) {
      for (languageIndex; languageIndex < languages.length; languageIndex++) {
        if ((languages[languageIndex].locale ?? Locale("en")).languageCode == appSettings.locale!.languageCode) {
          break;
        }
      }
    }
    controller = FixedExtentScrollController(
        initialItem: languageIndex
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 150,
        height: 150,
        child: CupertinoPicker(
            scrollController: controller,
            itemExtent: 30,
            onSelectedItemChanged: (i) {
              mainScreenKey.currentState?.setState(() {
                appSettings.locale = languages[i].locale;
              });
            }, children: languages)

    );
  }
}
