import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/models/note.dart';

class EditingNoteNotifier extends Notifier<Note> {
  @override
  Note build() {
    return Note(id: "");
  }

  void setNote(Note note) {
    state = note;
  }

  void setLineHeight(double? lineHeight) {
    final note = state;
    note.lineHeight = lineHeight;

    state = note;
  }

  void setTextColor(Color? textColor) {
    final note = state;
    note.textColor = textColor;

    state = note;
  }

  void setBackgroundColor(Color? backgroundColor) {
    final note = state;
    note.backgroundColor = backgroundColor;

    state = note;
  }

  void setTextSize(double? textSize) {
    final note = state;
    note.textSize = textSize;

    state = note;
  }
}

final editingNoteProvider = NotifierProvider<EditingNoteNotifier, Note>(EditingNoteNotifier.new);