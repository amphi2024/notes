import 'package:amphi/models/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/providers/selected_notes_provider.dart';
import 'package:notes/services/audio_service.dart';
import 'package:notes/services/videos_service.dart';
import 'package:notes/utils/document_conversion.dart';

import '../models/note.dart';
import '../pages/main/main_page.dart';
import '../pages/note_page.dart';
import '../providers/editing_note_provider.dart';
import '../providers/notes_provider.dart';
import '../providers/tables_provider.dart';

void onNotePressed(Note note, BuildContext context, WidgetRef ref) async {
  final selectedNotes = ref.watch(selectedNotesProvider);
  if(ref.watch(selectedNotesProvider.notifier).keyPressed) {
    if(selectedNotes!.contains(note.id)) {
      ref.read(selectedNotesProvider.notifier).removeId(note.id);
    }
    else {
      ref.read(selectedNotesProvider.notifier).addId(note.id);
    }
    return;
  }
  else {
    ref.read(selectedNotesProvider.notifier).endSelection();
  }

  prepareEmbeddedBlocks(ref, note);
  if(App.isWideScreen(context) || App.isDesktop()) {

    saveEditingNoteBeforeSwitch(ref);


    ref.read(editingNoteProvider.notifier).startEditing(note, false);

    ref.read(editingNoteProvider.notifier).initController(ref);
  }
  else {
    ref.read(editingNoteProvider.notifier).startEditing(note, false);
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return NotePage();
    }));
  }
}

void onFolderPressed(Note note, BuildContext context, WidgetRef ref) async {
  if (note.isFolder) {
    await ref.read(notesProvider).preloadNotes(note.id);
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return MainPage(folder: note);
    }));
  }
}

void saveEditingNoteBeforeSwitch(WidgetRef ref) {
  final oldNote = ref.watch(editingNoteProvider).note;
  if(oldNote.id.isNotEmpty && ref.watch(editingNoteProvider.notifier).controller.hasUndo) {
    oldNote.content = ref.watch(editingNoteProvider.notifier).controller.document.toNoteContent(ref);
    oldNote.modified = DateTime.now();
    oldNote.save();
    oldNote.initTitles();
    oldNote.initDelta();
    ref.read(notesProvider.notifier).insertNote(oldNote);
  }
}

void prepareEmbeddedBlocks(WidgetRef ref, Note note) {
  videosService.noteId = note.id;
  videosService.clear();
  audioService.noteId = note.id;
  audioService.clear();
  ref.read(tablesProvider.notifier).setTables(note.tables);
}