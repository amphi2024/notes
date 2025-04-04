import 'dart:async';
import 'dart:io';

import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/models/folder.dart';

import 'note.dart';

final appState = AppState.getInstance();

class AppState {

  static final AppState _instance = AppState._internal();

  AppState._internal();

  static AppState getInstance() => _instance;

  late void Function( void Function() ) notifySomethingChanged;
  late void Function( void Function() ) setMainViewState;
  List<Folder?> history = [null];

  late NoteEditingController noteEditingController;

  double noteListScrollPosition = 0;

  Timer? draftSaveTimer;

  Future<void> deleteDraft(Note note) async {
    File file = File(note.draftPath);
    if(await file.exists()) {
      await file.delete();
    }
  }

  void startDraftSave() {
    draftSaveTimer = Timer.periodic(Duration(minutes: 2), (t) async {
      if(!noteEditingController.readOnly) {
        var note = noteEditingController.getNote();
        note.saveDraft();
      }
    });
  }
}