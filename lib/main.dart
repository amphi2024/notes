import 'dart:io';
import 'dart:ui';

import 'package:amphi/models/app.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/pages/main_page.dart';
import 'package:notes/providers/notes_provider.dart';

import 'channels/app_method_channel.dart';
import 'channels/app_web_channel.dart';
import 'models/app_cache_data.dart';
import 'models/app_colors.dart';
import 'models/app_settings.dart';
import 'models/app_storage.dart';
import 'models/app_theme.dart';
import 'models/note.dart';
import 'pages/wide_main_page.dart';
import 'utils/data_sync.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (appSettings.useOwnServer) {
        if (!appWebChannel.connected) {
          appWebChannel.connectWebSocket();
        }
        ref.read(notesProvider.notifier).syncDataFromEvents();
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

      // appStorage.initNotes();
      // AppStorage.deleteObsoleteNotes();
      bool found = false;
      // for (dynamic item in AppStorage.getNoteList("")) {
      //   if (item is Note) {
      //     found = true;
      //     // appState.noteEditingController = NoteEditingController(note: item, readOnly: true);
      //     break;
      //   }
      // }
      if (!found) {
        // appState.noteEditingController = NoteEditingController(note: Note.createdNote(""), readOnly: false);
      }

      if (appSettings.useOwnServer) {
        appWebChannel.connectWebSocket();
      }

      appWebChannel.onWebSocketEvent = (updateEvent) {
        applyUpdateEvent(updateEvent, ref);
      };
      setState(() {

      });

      if (App.isDesktop()) {
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
          home: !App.isWideScreen(context) && !App.isDesktop() ? MainPage(folder: Note(id: "")) : const WideMainPage());
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
  if (appMethodChannel.needsBottomPadding) {
    return MediaQuery
        .of(context)
        .padding
        .bottom;
  }
  else {
    return 0;
  }
}