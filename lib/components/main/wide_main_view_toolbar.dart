import 'dart:io';

import 'package:amphi/models/app.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:notes/dialogs/draft_dialog.dart';
import '../../channels/app_method_channel.dart';
import '../../models/app_cache_data.dart';
import '../../models/app_settings.dart';
import '../../models/app_state.dart';
import '../../models/app_storage.dart';
import '../../models/note.dart';
import '../note_editor/note_editor.dart';
import '../note_editor/toolbar/note_editor_detail_button.dart';
import '../note_editor/toolbar/note_editor_export_button.dart';
import '../note_editor/toolbar/note_editor_import_button.dart';
import '../note_editor/toolbar/note_editor_redo_button.dart';
import '../note_editor/toolbar/note_editor_undo_button.dart';

class WideMainViewToolbar extends StatefulWidget {

  final void Function(void Function()) setState;
  final void Function() maximizeOrRestore;
  const WideMainViewToolbar({super.key, required this.setState, required this.maximizeOrRestore});

  @override
  State<WideMainViewToolbar> createState() => _WideMainViewToolbarState();
}

class _WideMainViewToolbarState extends State<WideMainViewToolbar> {

  bool isFullscreen = false;

  @override
  void dispose() {
    appMethodChannel.fullScreenListeners.remove(fullScreenListener);
    super.dispose();
  }

  void fullScreenListener(bool fullScreen) {
    setState(() {
      isFullscreen = fullScreen;
    });
  }

  @override
  void initState() {
    appMethodChannel.fullScreenListeners.add(fullScreenListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String location = appState.history.last?.filename ?? "";
    List<Widget> children = [
      NoteEditorExportButton(noteEditingController: appState.noteEditingController),
      NoteEditorDetailButton(noteEditingController: appState.noteEditingController),
      IconButton(icon: Icon(Icons.edit), onPressed: () {
        appState.noteEditingController.note.getDraft((draftNote) {
          appState.startDraftSave();
          if(draftNote != null) {
            showDialog(context: context, builder: (context) {
              return DraftDialog(
                onCanceled: () {
                  widget.setState(() {
                    appState.noteEditingController.readOnly = false;
                  });
                },
                onConfirmed: () {
                  appState.noteEditingController.note.contents = draftNote.contents;
                  appState.noteEditingController.setNote(appState.noteEditingController.note);
                  widget.setState(() {
                    appState.noteEditingController.readOnly = false;
                  });
                },
              );
            });
          }
          else {
            widget.setState(() {
              appState.noteEditingController.readOnly = false;
            });
          }
        });
        if(App.isDesktop()) {
          appCacheData.windowWidth = appWindow.size.width;
          appCacheData.windowHeight = appWindow.size.height;
          appCacheData.save();
        }
      }),

    ];

    if(App.isDesktop()) {
      children.insert(0,     Expanded(
        child: WindowTitleBarBox(child: MoveWindow(),),
      ));
    }

    if(!appState.noteEditingController.readOnly) {
      List<Widget> toolbarButtons = noteEditorToolbarButtons(appState.noteEditingController, (function) => widget.setState(function));
      if(App.isDesktop()) {
        toolbarButtons.insert(0, Expanded(child: WindowTitleBarBox(child: MoveWindow(),)));
        toolbarButtons.add(Expanded(child: WindowTitleBarBox(child: MoveWindow(),)));
      }

      children = [
        IconButton(icon: Icon(Icons.cancel_outlined), onPressed: () {
          showConfirmationDialog("@dialog_title_not_save_note", () {
            Note editingNote = appState.noteEditingController.note;
            appState.deleteDraft(editingNote);
            widget.setState(() {
              appState.noteEditingController.readOnly = true;
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
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: toolbarButtons,
          ),
        ),
        NoteEditorImportButton(noteEditingController: appState.noteEditingController),
        NoteEditorUndoButton(noteEditingController: appState.noteEditingController),
        NoteEditorRedoButton(noteEditingController: appState.noteEditingController),
        IconButton(icon: Icon(Icons.check_circle_outline), onPressed: () {
          appState.draftSaveTimer?.cancel();
          widget.setState(() {
            Note note = appState.noteEditingController.getNote();
            note.save();
            AppStorage.notifyNote(note);
            appState.noteEditingController.readOnly = true;
          });

          if(App.isDesktop()) {
            appCacheData.windowWidth = appWindow.size.width;
            appCacheData.windowHeight = appWindow.size.height;
            appCacheData.save();
          }
        }),
      ];
    }

    if(Platform.isWindows) {
      var colors = WindowButtonColors(
        iconMouseOver: Theme.of(context).textTheme.bodyMedium?.color,
        mouseOver: Color.fromRGBO(125, 125, 125, 0.1),
        iconNormal: Theme.of(context).textTheme.bodyMedium?.color,
        mouseDown: Color.fromRGBO(125, 125, 125, 0.1),
        iconMouseDown: Theme.of(context).textTheme.bodyMedium?.color,
      );
      children.add(  MinimizeWindowButton(
        colors: colors,
      ));
      children.add(   appWindow.isMaximized
          ? RestoreWindowButton(
        onPressed: widget.maximizeOrRestore,
        colors: colors,
      )
          : MaximizeWindowButton(
        onPressed: widget.maximizeOrRestore,
        colors: colors,

      ));
      children.add(CloseWindowButton());
    }

    double left = 50;
    double top = 6.5;

    if(Platform.isMacOS) {
      top = 1;
      if (!isFullscreen) {
        left = 115;
      }
    }

    if(appSettings.dockedFloatingMenu &&
        appSettings.floatingMenuShowing) {
      left = 5;
    }

    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      left: left,
      top: top,
      right: 5,
      child: Row(
        children: children,
      ),
    );
  }
}
