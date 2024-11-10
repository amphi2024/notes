import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/translations.dart';
import 'package:media_kit/media_kit.dart';
import 'package:notes/channels/app_method_channel.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/channels/app_web_download.dart';
import 'package:notes/channels/app_web_sync.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:amphi/models/app.dart';
import 'package:notes/models/app_colors.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/app_theme.dart';
import 'package:notes/models/folder.dart';
import 'package:notes/models/note.dart';
import 'package:amphi/models/update_event.dart';
import 'package:notes/views/main_view.dart';
import 'package:notes/views/wide_main_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  // prepareVideoPlayer();
  // VideoPlayer.prepare();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void websocketListener(updateEvent) {
    print("websocket received");
    switch (updateEvent.action) {
      case UpdateEvent.uploadNote:
        if (updateEvent.value.endsWith(".note")) {
          appWebChannel.downloadNote(
              filename: updateEvent.value,
              onSuccess: (item) {
                setState(() {
                  AppStorage.notifyNote(item);
                });
              });
        } else if (updateEvent.value.endsWith(".folder")) {
          appWebChannel.downloadFolder(
              filename: updateEvent.value,
              onSuccess: (folder) {
                setState(() {
                  AppStorage.notifyFolder(folder);
                });
              });
        }
        break;
      // case UpdateEvent.uploadImage:
      //   if (!File("${appStorage.imagesPath}/${updateEvent.value}").existsSync()) {
      //     appWebChannel.downloadImage(filename: updateEvent.value);
      //   }
      //   break;
      // case UpdateEvent.uploadVideo:
      //   if (!File("${appStorage.videosPath}/${updateEvent.value}").existsSync()) {
      //     appWebChannel.downloadVideo(filename: updateEvent.value);
      //   }
      //   break;
      case UpdateEvent.uploadTheme:
        appWebChannel.downloadTheme(filename: updateEvent.value);
        break;
      case UpdateEvent.renameUser:
        appStorage.selectedUser.name = updateEvent.value;
        appStorage.saveSelectedUserInformation();
        break;
      case UpdateEvent.deleteNote:
        for (dynamic item in AppStorage.trashes()) {
          if (item is Note && item.filename == updateEvent.value) {
            item.delete(upload: false);
            AppStorage.trashes().remove(item);
            break;
          } else if (item is Folder && item.filename == updateEvent.value) {
            item.delete(upload: false);
            AppStorage.trashes().remove(item);
            break;
          }
        }
        break;
      case UpdateEvent.deleteTheme:
        File file = File("${appStorage.selectedUser.storagePath}/themes/${updateEvent.value}");
        file.delete();
        break;
    }
    appWebChannel.acknowledgeEvent(updateEvent);
  }

  @override
  void dispose() {
    appWebChannel.removeWebSocketListener(websocketListener);
    super.dispose();
  }

  @override
  void initState() {
    appStorage.initialize(appMethodChannel, getData: () {
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
        appWebChannel.addWebSocketListener(websocketListener);
      }
    }, onInitialize: () {
      setState(() {});
    });

    appWebChannel.getDeviceInfo();
    if (Platform.isAndroid) {
      appMethodChannel.getSystemVersion();
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
         // debugShowCheckedModeBanner: false,
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
          home: !App.isWideScreen(context) ? MainView() : WideMainView());
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppTheme.lightGray
        ),
        darkTheme: ThemeData(
          scaffoldBackgroundColor: AppTheme.charCoal
        ),
        home: Scaffold(),
      );
    }
  }
}
