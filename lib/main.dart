import 'dart:io';
import 'dart:ui';

import 'package:amphi/models/app.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/translations.dart';
import 'package:media_kit/media_kit.dart';
import 'package:notes/channels/app_method_channel.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/channels/app_web_sync.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/models/app_cache_data.dart';
import 'package:notes/models/app_colors.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/app_theme.dart';
import 'package:notes/models/note.dart';
import 'package:notes/views/main_view.dart';
import 'package:notes/views/wide_main_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !App.isDesktop()) {

      AppStorage.deleteObsoleteNotes();
      if (appSettings.useOwnServer) {
        appWebChannel.connectWebSocket();

        appWebChannel.syncDataFromEvents();
        appWebChannel.noteUpdateListeners.add((note) {
          setState(() {
            AppStorage.notifyNote(note);
          });
        });

        appWebChannel.folderUpdateListeners.add((folder) {
          setState(() {
            AppStorage.notifyFolder(folder);
          });
        });
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    appCacheData.getData();
    appStorage.initialize(() {
      appSettings.getData();
      appColors.getData();

      appStorage.initNotes();
      AppStorage.deleteObsoleteNotes();
      bool found = false;
      for (dynamic item in AppStorage.getNoteList("")) {
        if (item is Note) {
          found = true;
          appState.noteEditingController = NoteEditingController(note: item, readOnly: true);
          break;
        }
      }
      if (!found) {
        appState.noteEditingController = NoteEditingController(note: Note.createdNote(""), readOnly: false);
      }

      if (appSettings.useOwnServer) {
        appWebChannel.connectWebSocket();

        appWebChannel.syncDataFromEvents();
        appWebChannel.noteUpdateListeners.add((note) {
          setState(() {
            AppStorage.notifyNote(note);
          });
        });

        appWebChannel.folderUpdateListeners.add((folder) {
          setState(() {
            AppStorage.notifyFolder(folder);
          });
        });
      }
      setState(() {

      });

      if(App.isDesktop()) {
        doWhenWindowReady(() {
          appWindow.minSize = Size(600, 350);
          appWindow.size = Size(appCacheData.windowWidth, appCacheData.windowHeight);
          appWindow.alignment = Alignment.center;
          appWindow.show();
        });
      }
    });

    appWebChannel.getDeviceInfo();
    if (Platform.isAndroid) {
      appMethodChannel.getSystemVersion();
      appMethodChannel.configureNeedsBottomPadding();
    }

    appState.notifySomethingChanged = (function) {
      setState(function);
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme? appTheme = appSettings.appTheme;
    Locale? locale = appSettings.locale;
    if (locale == null) {
      locale = PlatformDispatcher.instance.locale;
    }
    if (appTheme != null) {
      return MaterialApp(
           debugShowCheckedModeBanner: false,
          theme: appTheme.lightTheme.toThemeData(context),
          darkTheme: appTheme.darkTheme.toThemeData(context),
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            LocalizationDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            FlutterQuillLocalizations.delegate
          ],
          home: !App.isWideScreen(context) && !App.isDesktop() ? MainView() : WideMainView());
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: AppTheme.lightGray),
        darkTheme: ThemeData(scaffoldBackgroundColor: AppTheme.charCoal),
        home: Scaffold(),
      );
    }
  }
}

double bottomPaddingIfAndroid3Button(BuildContext context) {
  if(appMethodChannel.needsBottomPadding) {
    return MediaQuery.of(context).padding.bottom;
  }
  else {
    return 0;
  }

}