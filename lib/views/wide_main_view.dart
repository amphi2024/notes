import 'dart:io';

import 'package:amphi/models/update_event.dart';
import 'package:flutter/material.dart';
import 'package:notes/channels/app_method_channel.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/components/main/floating_menu/floating_wide_menu.dart';
import 'package:notes/components/note_editor/note_editor.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_sub_note_button.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_detail_button.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_image_button.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_redo_button.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_text_style_button.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_divider_button.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_edit_detail_button.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_table_button.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_undo_button.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_video_button.dart';
import 'package:amphi/models/app.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_view_pager_button.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/app_theme_data.dart';
import 'package:notes/models/note.dart';

class WideMainView extends StatefulWidget {
  final String? title;

  const WideMainView({super.key, this.title});

  @override
  State<WideMainView> createState() => _WideMainViewState();
}

class _WideMainViewState extends State<WideMainView> {
  bool floatingMenuShowing = true;
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
          appSettings.iosStyleUI);
    }

    final editorToolBar =  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NoteEditorTextStyleButton(noteEditingController: appState.noteEditingController),
        NoteEditorImageButton(noteEditingController: appState.noteEditingController),
        NoteEditorTableButton(noteEditingController: appState.noteEditingController),
        NoteEditorEditDetailButton(noteEditingController: appState.noteEditingController, onChange: (function) {
          setState(function);
        }),
        NoteEditorVideoButton(noteEditingController: appState.noteEditingController),
        NoteEditorSubNoteButton(noteEditingController: appState.noteEditingController),
        NoteEditorDividerButton(noteEditingController: appState.noteEditingController),
       NoteEditorViewPagerButton(noteEditingController: appState.noteEditingController),
      //  NoteEditorFileButton(noteEditingController: appState.noteEditingController),
        // NoteEditorChartButton(noteEditingController: appState.noteEditingController),
        // NoteEditorMindMapButton(noteEditingController: appState.noteEditingController),
        // NoteEditorAudioButton(noteEditingController: appState.noteEditingController),
      ],
    );

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
        backgroundColor: Theme.of(context).cardColor,
        body: Stack(
          children: [
            AnimatedPositioned(
              left: appSettings.dockedFloatingMenu &&
                      floatingMenuShowing
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
                      child: MediaQuery.of(context).size.width > 1000 ? editorToolBar : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: editorToolBar,
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeOutQuint,
                    left: appSettings.dockedFloatingMenu &&
                      floatingMenuShowing
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
                        NoteEditorDetailButton(noteEditingController: AppState.getInstance().noteEditingController),
                        IconButton(icon: Icon(Icons.edit), onPressed: () {
                          setState(() {
                            AppState.getInstance().noteEditingController.readOnly = false;

                          });
                        })
                      ] : [
                        NoteEditorUndoButton(noteEditingController: AppState.getInstance().noteEditingController),
                        NoteEditorRedoButton(noteEditingController: AppState.getInstance().noteEditingController),
                        IconButton(icon: Icon(Icons.check_circle_outline), onPressed: () {
                          setState(() {
                              Note note = AppState.getInstance().noteEditingController.getNote();
                              note.save();
                              AppStorage.notifyNote(note);
                              AppState.getInstance().noteEditingController.readOnly = true;
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
                              floatingMenuShowing = false;
                            });
                          }
                        },
                        child: Theme(
                          data: Theme.of(context).noteThemeData(context),
                          child: Scaffold(
                            body: NoteEditor(
                              noteEditingController: AppState.getInstance().noteEditingController,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            FloatingWideMenu(
                showing: floatingMenuShowing,
                focusNode: focusNode,
                onNoteSelected: (note) {
                  if(!AppState.getInstance().noteEditingController.readOnly) {
                    showConfirmationDialog("@dialog_title_not_save_note", () {
                      AppState.getInstance().noteEditingController.readOnly = true;
                      Note editingNote = AppState.getInstance().noteEditingController.note;
                      File file = File(editingNote.path);
                      if(!file.existsSync()) {
                        AppStorage.getNoteList(location).remove(editingNote);
                      }
                      AppState.getInstance().noteEditingController.setNote(note);
                    });
                  }
                  else {
                    AppState.getInstance().noteEditingController.readOnly = true;
                    AppState.getInstance().noteEditingController.setNote(note);
                  }
                },
            toCreateNote: (note) {
                  setState(() {
                    AppState.getInstance().noteEditingController.readOnly = false;
                    AppState.getInstance().noteEditingController.setNote(note);
                  });
            }),
            AnimatedPositioned(
                left: !appSettings.dockedFloatingMenu &&
                        floatingMenuShowing
                    ? 20
                    : 5,
                top: !appSettings.dockedFloatingMenu &&
                        floatingMenuShowing
                    ? 20
                    : 5,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOutQuint,
                child: GestureDetector(
                  onLongPress: () {
                    if (floatingMenuShowing) {
                      setState(() {
                        appSettings.dockedFloatingMenu =
                            !appSettings.dockedFloatingMenu;
                      });
                    }
                  },
                  child: IconButton(
                      icon: Icon(Icons.view_sidebar),
                      onPressed: () {
                        setState(() {
                          floatingMenuShowing = !floatingMenuShowing;
                        });
                      }),
                )),
          ],
        ),
      ),
    );
  }
}
