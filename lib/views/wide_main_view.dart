import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/channels/app_method_channel.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/components/main/floating_menu/floating_wide_menu.dart';
import 'package:notes/components/note_editor/note_editor.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_detail_button.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_export_button.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_redo_button.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_undo_button.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/app_theme_data.dart';
import 'package:notes/models/icons.dart';
import 'package:notes/models/note.dart';

import '../components/note_editor/toolbar/note_editor_import_button.dart';

class WideMainView extends StatefulWidget {
  final String? title;

  const WideMainView({super.key, this.title});

  @override
  State<WideMainView> createState() => _WideMainViewState();
}

class _WideMainViewState extends State<WideMainView> {
  FocusNode focusNode = FocusNode();

  void noteEditingListener() {
    Note note = appState.noteEditingController.getNote();
    note.initTitles();
    setState(() {
      AppStorage.replaceNote(note);
    });
  }

  @override
  void dispose() {
    appState.noteEditingController.removeListener(noteEditingListener);
    super.dispose();
  }

  @override
  void initState() {
   appState.noteEditingController.addListener(noteEditingListener);
   appWebChannel.noteUpdateListeners.add((note) {
     if(note.filename == appState.noteEditingController.note.filename) {
       setState(() {
         appState.noteEditingController.document = note.toDocument();
       });
     }
   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String location = appState.history.last?.filename ?? "";
    if (Platform.isAndroid) {
      appMethodChannel.setNavigationBarColor(
          Theme.of(context).scaffoldBackgroundColor,
          appSettings.transparentNavigationBar);
    }

    final editorToolBar =  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: noteEditorToolbarButtons(appState.noteEditingController, (function) => setState(function)),
    );

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
        backgroundColor: appState.noteEditingController.note.backgroundColorByTheme(isDarkMode) ?? themeData.cardColor,
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
                   Positioned(
                    left: 50,
                    right: 125,
                    top: 5,
                    child: Visibility(
                      visible: !appState.noteEditingController.readOnly,
                      // child: MediaQuery.of(context).size.width > 1000 ? editorToolBar : SingleChildScrollView(
                      //   scrollDirection: Axis.horizontal,
                      //   child: editorToolBar,
                      // ),
                      child: editorToolBar,
                    ),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeOutQuint,
                    left: appSettings.dockedFloatingMenu &&
                      appSettings.floatingMenuShowing
                      ? 5
                      : 50,
                    top: 5,
                    child: Visibility(
                      visible: !appState.noteEditingController.readOnly,
                      child: IconButton(icon: Icon(Icons.cancel_outlined), onPressed: () {
                        showConfirmationDialog("@dialog_title_not_save_note", () {
                          setState(() {
                            appState.noteEditingController.readOnly = true;
                            Note editingNote = appState.noteEditingController.note;
                            File file = File(editingNote.path);
                            if(!file.existsSync()) {
                              AppStorage.getNoteList(location).remove(editingNote);
                            }
                            else {
                              File file = File(appState.noteEditingController.note.path);
                              Note originalNote = Note.fromFile(file);
                              appState.noteEditingController.setNote(originalNote);
                              originalNote.initTitles();
                              AppStorage.replaceNote(originalNote);
                            }
                          });
                        });
                      }),
                    ),
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: appState.noteEditingController.readOnly ? [
                        NoteEditorExportButton(noteEditingController: appState.noteEditingController),
                        NoteEditorDetailButton(noteEditingController: appState.noteEditingController),
                        IconButton(icon: Icon(Icons.edit), onPressed: () {
                          setState(() {
                            appState.noteEditingController.readOnly = false;
                          });
                        })
                      ] : [
                        NoteEditorImportButton(noteEditingController: appState.noteEditingController),
                        NoteEditorUndoButton(noteEditingController: appState.noteEditingController),
                        NoteEditorRedoButton(noteEditingController: appState.noteEditingController),
                        IconButton(icon: Icon(Icons.check_circle_outline), onPressed: () {
                          setState(() {
                              Note note = appState.noteEditingController.getNote();
                              note.save();
                              AppStorage.notifyNote(note);
                              appState.noteEditingController.readOnly = true;
                          });
                        }),
                      ],
                    ),
                  ),
                  Positioned(
                      left: 15,
                      top: 65,
                      bottom: 15,
                      right: 15,
                      child: GestureDetector(
                        onTap: () {
                          if(!appSettings.dockedFloatingMenu) {
                            setState(() {
                              if(focusNode.hasFocus) {
                                focusNode.unfocus();
                              }
                              appSettings.floatingMenuShowing = false;
                            });
                          }
                        },
                        child: Theme(
                          data: Theme.of(context).noteThemeData(),
                          child: Scaffold(
                            backgroundColor: appState.noteEditingController.note.backgroundColorByTheme(Theme.of(context).brightness == Brightness.dark) ?? themeData.cardColor,
                            body: NoteEditor(
                              noteEditingController: appState.noteEditingController,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            FloatingWideMenu(
                showing: appSettings.floatingMenuShowing,
                focusNode: focusNode,
                onNoteSelected: (note) {
                  if(!appState.noteEditingController.readOnly) {
                    showConfirmationDialog("@dialog_title_not_save_note", () {
                      appState.noteEditingController.readOnly = true;
                      Note editingNote = appState.noteEditingController.note;
                      File file = File(editingNote.path);
                      if(!file.existsSync()) {
                        AppStorage.getNoteList(location).remove(editingNote);
                      }
                      appState.noteEditingController.setNote(note);
                    });
                  }
                  else {
                    appState.noteEditingController.readOnly = true;
                    appState.noteEditingController.setNote(note);
                  }
                },
            toCreateNote: (note) {
                  setState(() {
                    appState.noteEditingController.readOnly = false;
                    appState.noteEditingController.setNote(note);
                  });
            }),
            AnimatedPositioned(
                left: !appSettings.dockedFloatingMenu &&
                        appSettings.floatingMenuShowing
                    ? 20
                    : 5,
                top: !appSettings.dockedFloatingMenu &&
                        appSettings.floatingMenuShowing
                    ? 20
                    : 5,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOutQuint,
                child: GestureDetector(
                  onLongPress: () {
                    if (appSettings.floatingMenuShowing) {
                      setState(() {
                        appSettings.dockedFloatingMenu =
                            !appSettings.dockedFloatingMenu;
                      });
                      appSettings.save();
                    }
                  },
                  child: IconButton(
                      icon: Icon(AppIcons.sidebar),
                      onPressed: () {
                        setState(() {
                          appSettings.floatingMenuShowing = !appSettings.floatingMenuShowing;
                        });
                        appSettings.save();
                      }),
                )),
          ],
        ),
      ),
    );
  }
}
