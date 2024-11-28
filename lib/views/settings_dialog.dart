import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/channels/app_method_channel.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/components/settings/server_setting_component.dart';
import 'package:notes/components/settings/theme_select_dialog.dart';
import 'package:notes/components/settings/titled_check_box.dart';
import 'package:notes/components/settings/titled_widget.dart';
import 'package:notes/methods/get_themes.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/app_theme.dart';
import 'package:notes/models/icons.dart';
import 'package:amphi/widgets/settings/language.dart';
import 'package:notes/views/settings_view.dart';

class SettingsDialog extends SettingsView {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _DesktopSettingsViewState();
}

class _DesktopSettingsViewState extends State<SettingsDialog> {
  TextEditingController serverAddressController = TextEditingController();

  late List<AppTheme> themeList = allThemes();
  late List<DropdownMenuItem<Locale?>> languageDropdownItems = Language.dropdownItems(context);

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
    return PopScope(
      onPopInvokedWithResult: (value, result) {
        appSettings.serverAddress = serverAddressController.text;
        appSettings.save();
        if (!appWebChannel.connected && appSettings.useOwnServer) {
          appWebChannel.connectWebSocket();
        }
      },
      child: Dialog(
        child: Container(
          width: 450,
          height:  MediaQuery.of(context).size.height >= 500 ? 500 : null,
          child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      icon: Icon(AppIcons.times),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                Positioned(
                  left: 10,
                    right: 10,
                    top: 50,
                    bottom: 10,
                    child:   SingleChildScrollView(
                  child: Column(
                    children: [
                      Visibility(
                          visible: Platform.isAndroid &&
                              appMethodChannel.systemVersion! >= 29,
                          child: TitledCheckBox(
                              title: AppLocalizations.of(context).get("@transparent_navigation_bar"),
                              value: appSettings.transparentNavigationBar,
                              onChanged: (value) {
                                setState(() {
                                  appSettings.transparentNavigationBar = value!;
                                });
                              })),
                      TitledCheckBox(
                          title: AppLocalizations.of(context).get("@use_my_own_server"),
                          value: appSettings.useOwnServer,
                          onChanged: (value) {
                            setState(() {
                              appSettings.useOwnServer = value!;
                            });
                          }),
                      ServerSettingComponent(serverAddressController: serverAddressController),
                      TitledWidget(
                          title: AppLocalizations.of(context).get("@language"),
                          widget: DropdownButton<Locale?>(
                              value: appSettings.locale,
                              items: languageDropdownItems,
                              onChanged: (item) {
                                appState.notifySomethingChanged(() {
                                  appSettings.locale = item;
                                });
                              })),
                      TitledWidget(
                          title: AppLocalizations.of(context).get("@theme"),
                          widget: IconButton(
                              icon: Icon(
                                Icons.circle,
                                size: 40,
                              ),
                              onPressed: () {
                                showDialog(context: context, builder: (context) {
                                  return ThemeSelectDialog(themeList: themeList);
                                });
                              })
                      )
                    ],
                  ),
                ))

              ]),
        ),
      ),
    );
  }
}
