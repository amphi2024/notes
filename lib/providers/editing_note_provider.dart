import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:notes/utils/document_conversion.dart';
import 'package:notes/utils/note_import_utils.dart';

import '../models/app_cache_data.dart';
import '../utils/generate_id.dart';
import '../utils/note_item_press_callback.dart';

class EditingNoteState {
  final Note note;
  final bool editing;
  EditingNoteState(this.note, this.editing);
}

class EditingNoteNotifier extends Notifier<EditingNoteState> {

  Timer? timer;
  QuillController? _controller;

  QuillController get controller {
    if(_controller == null) {
      _controller = QuillController(document: Document.fromDelta(state.note.delta), selection: TextSelection(baseOffset: 0, extentOffset: 0));
    }
    return _controller!;
  }

  @override
  EditingNoteState build() {
    return EditingNoteState(Note(id: ""), true);
  }

  void initController(WidgetRef ref) {
    _controller?.dispose();
    _controller = QuillController(document: Document.fromDelta(state.note.delta), selection: TextSelection(baseOffset: 0, extentOffset: 0));

    controller.addListener(() {
      if(controller.hasUndo) {
        final note = state.note;
        var title = "";
        var subtitle = "";
        String? thumbnail = note.thumbnailImageFilename;
        for (var operation in controller.document.toDelta().toList()) {
          final value = operation.value;
          if (value is String) {
            List<String> textLines = operation.value.split("\n");
            if (textLines.length > 1) {
              for (String line in textLines) {
                if (line.trim().isNotEmpty) {
                  if (title.isEmpty) {
                    title = line;
                  } else {
                    if (subtitle.isEmpty) {
                      subtitle = line;
                    }
                  }
                }
              }
            } else {
              if (operation.value.trim().isNotEmpty) {
                if (title.isEmpty) {
                  title = operation.value;
                } else {
                  if (subtitle.isEmpty) {
                    subtitle = operation.value;
                  }
                }
              }
            }
          }
          if (thumbnail != null && title.isNotEmpty && subtitle.isNotEmpty) {
            break;
          }
        }

        ref.read(notesProvider.notifier).updateNotePreview(
            noteId: note.id,
            title: title,
            subtitle: subtitle,
            thumbnailImageFilename: thumbnail
        );
      }
    });

    controller.document.changes.listen((data) {
      timer?.cancel();
      timer = Timer(Duration(seconds: 2), () async {
        final note = state.note;
        note.content = controller.document.toNoteContent(ref);
        note.modified = DateTime.now();
        await note.save();
        ref.read(notesProvider.notifier).insertNote(note);
      });
    });
  }

  void startEditing(Note note, bool editing) {
    state = EditingNoteState(note, editing);
    appCacheData.editingNote = note.id;
    appCacheData.save();
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

Future<void> initEditingNote(WidgetRef ref) async {
  final notesState = ref.read(notesProvider);
  final note = notesState.notes[appCacheData.editingNote] ?? notesState.notes[notesState.idLists[""]!.firstOrNull];
  if (note != null) {
    prepareEmbeddedBlocks(ref, note);
    ref.read(editingNoteProvider.notifier).startEditing(note, true);
    ref.read(editingNoteProvider.notifier).initController(ref);
  } else {
    final byteData = await rootBundle.load("assets/welcome.note");

    final fileContent = utf8.decode(byteData.buffer.asUint8List().toList());
    final id = await generatedNoteId();
    final note = Note(id: id);
    prepareEmbeddedBlocks(ref, note);
    ref.read(editingNoteProvider.notifier).startEditing(note, true);
    ref.read(editingNoteProvider.notifier).initController(ref);
    await ref.read(editingNoteProvider.notifier).controller.importNote(noteId: note.id, fileContent: fileContent, ref: ref);
    note.initDelta();
    note.content = ref.read(editingNoteProvider.notifier).controller.document.toNoteContent(ref);
    note.initDelta();
    note.initTitles();
    await note.save();
    ref.read(notesProvider.notifier).insertNote(note);
  }
}