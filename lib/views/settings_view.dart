import 'dart:io';

import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/widgets/settings/language.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/settings/theme_settings.dart';
import 'package:notes/main.dart';

import '../channels/app_method_channel.dart';
import '../channels/app_web_channel.dart';
import '../components/settings/server_settings.dart';
import '../components/settings/titled_check_box.dart';
import '../models/app_settings.dart';
import '../models/theme_model.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {

  TextEditingController serverAddressController = TextEditingController();

  late final languages = Language.items(context);
  late final FixedExtentScrollController languageScrollController;

  @override
  void dispose() {
    serverAddressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    serverAddressController.text = appWebChannel.serverAddress;

    int languageIndex = 0;
    if (appSettings.locale != null) {
      for (languageIndex; languageIndex < languages.length; languageIndex++) {
        if ((languages[languageIndex].locale ?? Locale("en")).languageCode == appSettings.locale!.languageCode) {
          break;
        }
      }
    }
    languageScrollController = FixedExtentScrollController(
        initialItem: languageIndex
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ListView(
        children: [
          Visibility(
              visible: Platform.isAndroid && appMethodChannel.systemVersion >= 29,
              child: TitledCheckBox(
                  title: AppLocalizations.of(context).get("@transparent_navigation_bar"),
                  value: appSettings.transparentNavigationBar,
                  onChanged: (value) {
                    setState(() {
                      appSettings.transparentNavigationBar = value!;
                      appMethodChannel.setNavigationBarColor(
                          Theme
                              .of(context)
                              .scaffoldBackgroundColor
                      );
                    });
                  })),
          TitledCheckBox(
              title: AppLocalizations.of(context).get("@use_my_own_server"),
              value: appSettings.useOwnServer,
              onChanged: (value) {
                setState(() {
                  appSettings.useOwnServer = value;
                });
              }),
          ServerSettings(serverAddressController: serverAddressController),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    AppLocalizations.of(context).get("@theme"),
                  ),
                  const ThemeSettings(),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context).get("@language")),
                  SizedBox(
                      width: 150,
                      height: 150,
                      child: CupertinoPicker(
                          scrollController: languageScrollController,
                          itemExtent: 30,
                          onSelectedItemChanged: (i) {
                            mainScreenKey.currentState?.setState(() {
                              appSettings.locale = languages[i].locale;
                            });;
                          }, children: languages)

                  ),
                ],
              ),
            ],
          ),
        ]);
  }
}
