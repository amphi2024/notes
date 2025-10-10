import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/note.dart';
import '../pages/main_page.dart';
import '../pages/note_page.dart';
import '../providers/editing_note_provider.dart';
import '../providers/notes_provider.dart';

void onNotePressed(Note note, BuildContext context, WidgetRef ref) {
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
