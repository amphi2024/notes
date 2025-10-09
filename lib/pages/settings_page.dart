import 'dart:io';

import 'package:amphi/models/app_server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/channels/app_method_channel.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/components/draggable_page.dart';
import 'package:notes/components/settings/app_theme_page_view.dart';
import 'package:notes/components/settings/server_setting_component.dart';
import 'package:notes/components/settings/titled_check_box.dart';
import 'package:notes/utils/get_themes.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_theme.dart';
import 'package:notes/icons/icons.dart';
import 'package:amphi/widgets/settings/language.dart';

class SettingsPage extends StatefulWidget {

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  TextEditingController serverAddressController = TextEditingController();

  late List<AppTheme> themeList = allThemes();
  late List<Language> languages = Language.items(context);
  late FixedExtentScrollController languageScrollController;
  AppServer? selectedServer;

  @override
  void dispose() {
    serverAddressController.dispose();
    super.dispose();
  }

  late AppTheme selectedTheme = appSettings.appTheme!;
  // data: Theme.of(context).brightness == Brightness.light ? selectedTheme.lightTheme.toThemeData() : selectedTheme.darkTheme.toThemeData(),
  @override
  void initState() {
    serverAddressController.text = appWebChannel.serverAddress;

    int languageIndex = 0;
    if(appSettings.locale != null) {
      for(languageIndex; languageIndex < languages.length; languageIndex++) {
        if((languages[languageIndex].locale?? Locale("en")).languageCode == appSettings.locale!.languageCode) {
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
    return DraggablePage(
      canPopPage: true,
      onPopInvoked: (value, result) {
          appSettings.serverAddress = serverAddressController.text;
          appSettings.save();
          if (!appWebChannel.connected && appSettings.useOwnServer) {
            appWebChannel.connectWebSocket();
          }
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 300,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     const Icon(
                      AppIcons.back,
                      size: 25,
                    ),
                    Text(AppLocalizations.of(context).get("@settings"))
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
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
                          Theme.of(context).scaffoldBackgroundColor
                        );
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    // AppThemePageView(
                    //   themeList: themeList,
                    //   onPageChanged: (AppTheme theme) {
                    //     // setState(() {
                    //     //   selectedTheme = theme;
                    //     // });
                    //     // appState.notifySomethingChanged(() {
                    //     //   appSettings.appTheme = theme;
                    //     // });
                    //   },
                    // ),
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
                            //
                            // appState.notifySomethingChanged(() {
                            //   appSettings.locale = languages[i].locale;
                            // });
                          }, children: languages)

                    ),
                  ],
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}