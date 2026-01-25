import 'dart:io';

import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/settings/language_settings.dart';
import 'package:notes/components/settings/theme_settings.dart';

import '../channels/app_method_channel.dart';
import '../channels/app_web_channel.dart';
import '../components/settings/server_settings.dart';
import '../components/settings/titled_check_box.dart';
import '../main.dart';
import '../models/app_settings.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {

  TextEditingController serverAddressController = TextEditingController();

  @override
  void dispose() {
    serverAddressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    serverAddressController.text = appWebChannel.serverAddress;
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
                      appSettings.transparentNavigationBar = value;
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
          Visibility(
              visible: appSettings.useOwnServer,
              child: TitledCheckBox(
                  title: AppLocalizations.of(context).get("automatically_check_server_updates"),
                  value: appSettings.autoCheckServerUpdate,
                  onChanged: (value) {
                    setState(() {
                      appSettings.autoCheckServerUpdate = value;
                    });
                  })),
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
                  LanguageSettings()
                ],
              ),
            ],
          ),
          TitledCheckBox(
              title: AppLocalizations.of(context).get("automatically_check_updates"),
              value: appSettings.autoCheckUpdate,
              onChanged: (value) {
                setState(() {
                  appSettings.autoCheckUpdate = value;
                });
              }),
          Visibility(
              visible: Platform.isLinux,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Row(
                  children: [
                    Text("Window Controls Style"),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: DropdownButton<String?>(
                          value: appSettings.windowControlsStyle,
                          items: [
                            DropdownMenuItem(value: "yaru", child: Text("Yaru")),
                            DropdownMenuItem(value: "arc", child: Text("Arc")),
                            DropdownMenuItem(
                                value: "breeze", child: Text("Breeze")),
                            DropdownMenuItem(
                                value: "elementary", child: Text("Elementary")),
                            DropdownMenuItem(
                                value: "flatRemix", child: Text("Flat Remix")),
                            DropdownMenuItem(
                                value: "materia", child: Text("Materia")),
                            DropdownMenuItem(
                                value: "nordic", child: Text("Nordic")),
                            DropdownMenuItem(value: "pop", child: Text("Pop")),
                            DropdownMenuItem(value: "unity", child: Text("Unity")),
                            DropdownMenuItem(value: "vimix", child: Text("Vimix")),
                            DropdownMenuItem(
                                value: "osxarc", child: Text("OSx Arc")),
                            DropdownMenuItem(value: null, child: Text("Adwaita"))
                          ],
                          onChanged: (value) {
                            mainScreenKey.currentState?.setState(() {
                              appSettings.windowControlsStyle = value;
                            });
                            setState(() {});
                          }),
                    )
                  ],
                ),
              )),
          Visibility(
              visible: Platform.isLinux,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Row(
                  children: [
                    Text("Window Controls on Left"),
                    Checkbox(
                        value: appSettings.windowButtonsOnLeft,
                        onChanged: (value) {
                          if (value != null) {
                            mainScreenKey.currentState?.setState(() {
                              appSettings.windowButtonsOnLeft = value;
                            });
                            setState(() {});
                          }
                        })
                  ],
                ),
              ))
        ]);
  }
}
