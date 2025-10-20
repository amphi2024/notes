import 'dart:io';

import 'package:amphi/models/app.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:notes/channels/app_method_channel.dart';
import 'package:notes/pages/main/menu/floating_wide_menu.dart';
import 'package:notes/pages/main/side_bar_toggle_button.dart';
import 'package:notes/pages/main/wide_main_view_toolbar.dart';
import 'package:notes/models/app_cache_data.dart';
import 'package:notes/models/app_settings.dart';

import 'package:notes/models/app_theme_data.dart';


class WideMainPage extends StatefulWidget {
  final String? title;

  const WideMainPage({super.key, this.title});

  @override
  State<WideMainPage> createState() => _WideMainPageState();
}

class _WideMainPageState extends State<WideMainPage> {
  FocusNode focusNode = FocusNode();

  void noteEditingListener() {
    // Note note = appState.noteEditingController.getNote();
    // note.initTitles();
    // setState(() {
    //   AppStorage.replaceNote(note);
    // });
  }

  @override
  void dispose() {
    // appState.noteEditingController.removeListener(noteEditingListener);
    super.dispose();
  }

  @override
  void initState() {
   //  appState.setMainViewState = setState;
   // appState.noteEditingController.addListener(noteEditingListener);
   // appWebChannel.noteUpdateListeners.add((note) {
   //   if(note.filename == appState.noteEditingController.note.filename) {
   //     setState(() {
   //       appState.noteEditingController.document = note.toDocument();
   //     });
   //   }
   // });
    super.initState();
  }

  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    // String location = appState.history.last?.filename ?? "";
    String location = "";
    if (Platform.isAndroid) {
      appMethodChannel.setNavigationBarColor(Theme.of(context).scaffoldBackgroundColor);
    }

    var themeData = Theme.of(context);
    var isDarkMode = themeData.brightness == Brightness.dark;

    return MouseRegion(
      // onHover: (event) {
      //   if (App.isDesktop() && !appSettings.dockedFloatingMenu) {
      //     if (floatingMenuShowing) {
      //       if (event.position.dx >= 265) {
      //         setState(() {
      //           floatingMenuShowing = false;
      //         });
      //       }
      //     } else {
      //       if (event.position.dx <= 20) {
      //         setState(() {
      //           floatingMenuShowing = true;
      //         });
      //       }
      //     }
      //   }
      // },
      child: Scaffold(
        // backgroundColor: appState.noteEditingController.note.backgroundColorByTheme(isDarkMode) ?? themeData.cardColor,
        backgroundColor: themeData.cardColor,
        body: Stack(
          children: [
            AnimatedPositioned(
              left: appSettings.dockedFloatingMenu &&
                      appSettings.floatingMenuShowing
                  ? 250
                  : 0,
              right: 0,
              top: 0,
              bottom: 0,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOutQuint,
              child: Stack(
                children: [
                  WideMainViewToolbar(setState: setState, maximizeOrRestore: maximizeOrRestore),
                  Positioned(
                      left: 15,
                      top: Platform.isAndroid ? 50 + MediaQuery.of(context).padding.top : 50,
                      bottom: 15,
                      right: 15,
                      child: Theme(
                        data: Theme.of(context).noteThemeData(),
                        child: Scaffold(
                          // backgroundColor: appState.noteEditingController.note.backgroundColorByTheme(Theme.of(context).brightness == Brightness.dark) ?? themeData.cardColor,
                          backgroundColor: themeData.cardColor,
                          // body: NoteEditor(
                          //   noteEditingController: appState.noteEditingController,
                          // ),
                        ),
                      )),
                ],
              ),
            ),
            FloatingWideMenu(
                showing: appSettings.floatingMenuShowing,
                focusNode: focusNode,
                onNoteSelected: (note) {
                  // if(!appState.noteEditingController.readOnly) {
                  //   showConfirmationDialog("@dialog_title_not_save_note", () {
                  //     appState.noteEditingController.readOnly = true;
                  //     Note editingNote = appState.noteEditingController.note;
                  //     File file = File(editingNote.path);
                  //     if(!file.existsSync()) {
                  //       AppStorage.getNoteList(location).remove(editingNote);
                  //     }
                  //     appState.noteEditingController.setNote(note);
                  //   });
                  // }
                  // else {
                  //   // appState.noteEditingController.readOnly = true;
                  //   // appState.noteEditingController.setNote(note);
                  // }

                  if(App.isDesktop()) {
                    appCacheData.windowWidth = appWindow.size.width;
                    appCacheData.windowHeight = appWindow.size.height;
                    appCacheData.save();
                  }
                },
            toCreateNote: (note) {
              // appState.startDraftSave();
              //     setState(() {
              //       appState.noteEditingController.readOnly = false;
              //       appState.noteEditingController.setNote(note);
              //     });
            }),
            SideBarToggleButton(setState: setState),
          ],
        ),
      ),
    );
  }
}
