import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/models/note.dart';

class EditingNoteState {
  final Note note;
  final bool editing;
  EditingNoteState(this.note, this.editing);
}

class EditingNoteNotifier extends Notifier<EditingNoteState> {

  Note? originalNote;

  @override
  EditingNoteState build() {
    return EditingNoteState(Note(id: ""), true);
  }

  void startEditing(Note note, bool editing) {
    originalNote = note;
    state = EditingNoteState(note, editing);
  }

  void setLineHeight(double? lineHeight) {
    final note = state.note;
    note.lineHeight = lineHeight;

    state = EditingNoteState(note, state.editing);
  }

  void setTextColor(Color? textColor) {
    final note = state.note;
    note.textColor = textColor;

    state = EditingNoteState(note, state.editing);
  }

  void setBackgroundColor(Color? backgroundColor) {
    final note = state.note;
    note.backgroundColor = backgroundColor;

    state = EditingNoteState(note, state.editing);
  }

  void setTextSize(double? textSize) {
    final note = state.note;
    note.textSize = textSize;

    state = EditingNoteState(note, state.editing);
  }

  void setEditing(bool value) {
    state = EditingNoteState(state.note, value);
  }
}

final editingNoteProvider = NotifierProvider<EditingNoteNotifier, EditingNoteState>(EditingNoteNotifier.new);