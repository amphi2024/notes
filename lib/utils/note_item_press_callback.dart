import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/services/audio_service.dart';
import 'package:notes/services/videos_service.dart';

import '../models/note.dart';
import '../pages/main/main_page.dart';
import '../pages/note_page.dart';
import '../providers/editing_note_provider.dart';
import '../providers/notes_provider.dart';
import '../providers/tables_provider.dart';

void onNotePressed(Note note, BuildContext context, WidgetRef ref) async {
  videosService.noteId = note.id;
  videosService.clear();
  audioService.noteId = note.id;
  audioService.clear();
  ref.read(tablesProvider.notifier).setTables(note.tables);
  ref.read(editingNoteProvider.notifier).startEditing(note, false);
  Navigator.push(context, CupertinoPageRoute(builder: (context) {
    return NotePage();
  }));
}

void onFolderPressed(Note note, BuildContext context, WidgetRef ref) async {
  if (note.isFolder) {
    await ref.read(notesProvider).preloadNotes(note.id);
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return MainPage(folder: note);
    }));
  }
}
