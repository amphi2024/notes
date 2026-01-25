import 'dart:io';
import 'dart:ui';

import 'package:amphi/models/app_localizations.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:notes/utils/screen_size.dart';
import 'package:window_manager/window_manager.dart';
import 'database/database_helper.dart';
import 'pages/main/main_page.dart';
import 'package:notes/providers/editing_note_provider.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:notes/providers/themes_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'channels/app_method_channel.dart';
import 'channels/app_web_channel.dart';
import 'models/app_cache_data.dart';
import 'models/app_colors.dart';
import 'models/app_settings.dart';
import 'models/app_storage.dart';
import 'models/note.dart';
import 'pages/main/wide_main_page.dart';
import 'utils/data_sync.dart';

final mainScreenKey = GlobalKey<_MyAppState>();

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
  }

  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await appCacheData.getData();

  await appStorage.initialize();

  await appSettings.getData();
  appColors.getData();

  final notesState = await NotesNotifier.initialized();
  final themesState = await ThemesNotifier.initialized();

  if (Platform.isLinux) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      size: Size(appCacheData.data["windowWidth"] ?? 1280, appCacheData.data["windowHeight"] ?? 720),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: appSettings.prefersCustomTitleBar ? TitleBarStyle.hidden : TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(ProviderScope(
      overrides: [notesProvider.overrideWithBuild((ref, notifier) => notesState), themesProvider.overrideWithBuild((ref, notifier) => themesState),
        editingNoteProvider.overrideWithBuild((ref, notifier) => EditingNoteState(notesState.notes.get(appCacheData.editingNote), true))
      ],
      child: MyApp(key: mainScreenKey)));

  if (Platform.isWindows || Platform.isMacOS) {
    doWhenWindowReady(() {
      appWindow.minSize = Size(600, 350);
      appWindow.size = Size(appCacheData.windowWidth, appCacheData.windowHeight);
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });
  }
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
        appWebChannel.getServerVersion(onSuccess: (version) {
          if (version.startsWith("1.")) {
            appWebChannel.uploadBlocked = true;
          } else {
            appWebChannel.uploadBlocked = false;
          }
        }, onFailed: (code) {
          appWebChannel.uploadBlocked = true;
        });
        if (!appWebChannel.connected) {
          appWebChannel.connectWebSocket();
        }
        syncDataWithServer(ref);
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    databaseHelper.close();
    super.dispose();
  }

  @override
  void initState() {
    if (appSettings.useOwnServer) {
      appWebChannel.getServerVersion(onSuccess: (version) {
        if (version.startsWith("1.")) {
          appWebChannel.uploadBlocked = true;
        }
      }, onFailed: (code) {
        appWebChannel.uploadBlocked = true;
      });
    }
    WidgetsBinding.instance.addObserver(this);

    if (appSettings.useOwnServer) {
      appWebChannel.connectWebSocket();
      syncDataWithServer(ref);
    }

    appWebChannel.onWebSocketEvent = (updateEvent) async {
      applyUpdateEvent(updateEvent, ref);
    };

    appWebChannel.getDeviceInfo();
    if (Platform.isAndroid) {
      appMethodChannel.getSystemVersion();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initEditingNote(ref);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Locale? locale = appSettings.locale;
    if (locale == null) {
      locale = PlatformDispatcher.instance.locale;
    }
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appSettings.themeModel.toThemeData(context: context, brightness: Brightness.light),
        darkTheme: appSettings.themeModel.toThemeData(context: context, brightness: Brightness.dark),
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          LocalizationDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          FlutterQuillLocalizations.delegate
        ],
        home: isDesktopOrTablet(context) ? const WideMainPage() : MainPage(folder: Note(id: "")));
  }
}
