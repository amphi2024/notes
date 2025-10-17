import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/channels/app_method_channel.dart';
import 'package:notes/components/note_editor/note_editor_toolbar.dart';
import 'package:notes/components/note_editor/note_editor.dart';
import 'package:notes/components/note_page_app_bar.dart';
import 'package:notes/icons/icons.dart';
import 'package:notes/models/note_embed_blocks.dart';
import 'package:notes/providers/editing_note_provider.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:notes/utils/document_conversion.dart';

class NotePage extends ConsumerStatefulWidget {
  const NotePage({super.key});

  @override
  ConsumerState<NotePage> createState() => _NotePageState();
}

class _NotePageState extends ConsumerState<NotePage> {
  late final controller = QuillController(
      document: Document.fromDelta(ref.watch(editingNoteProvider).note.delta),
      selection: TextSelection(baseOffset: 0, extentOffset: 0));
  final focusNode = FocusNode();
  Timer? timer;

  @override
  void dispose() {
    noteEmbedBlocks.clear();
    controller.dispose();
    focusNode.dispose();
    timer?.cancel();
    super.dispose();
  }

  void startEditingListener() {
    if(controller.hasUndo) {
      ref.read(editingNoteProvider.notifier).setEditing(true);
      controller.removeListener(startEditingListener);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.addListener(startEditingListener);
      controller.document.changes.listen((data) {
        timer?.cancel();
        timer = Timer(Duration(seconds: 2), () async {
          final note = ref.watch(editingNoteProvider).note;
          note.content = controller.document.toNoteContent(ref);
          note.modified = DateTime.now();
          note.save(upload: false);
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final note = ref.watch(editingNoteProvider).note;
    appMethodChannel
        .setNavigationBarColor(note.backgroundColorByTheme(context));
    var bottomPadding = MediaQuery.of(context).padding.bottom;
    final editing = ref.watch(editingNoteProvider).editing;
    if(bottomPadding > 5) {
      bottomPadding = 5;
    }
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if(controller.hasUndo) {
          note.content = controller.document.toNoteContent(ref);
          note.modified = DateTime.now();
          note.initTitles();
          note.save();
          note.initDelta();
          ref.read(notesProvider.notifier).insertNote(note);
        }
      },
      child: Scaffold(
          backgroundColor: note.backgroundColorByTheme(context),
          appBar: AppBar(
            backgroundColor: note.backgroundColorByTheme(context),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(AppIcons.back, size: 25)),
            actions: notePageAppbarActions(context: context, ref: ref, note: note, controller: controller, editing: editing, onSave: () {
              note.modified = DateTime.now();
              note.content = controller.document.toNoteContent(ref);
              note.save();
              note.initTitles();
              note.initDelta();
              ref.read(notesProvider.notifier).insertNote(note);
              ref.read(editingNoteProvider.notifier).setEditing(false);
              controller.addListener(startEditingListener);
              focusNode.unfocus();
            }),
          ),
          body: Stack(
            children: [
              Positioned(
                  left: 10,
                  right: 10,
                  bottom: editing ? 60 + bottomPadding : 0 + bottomPadding,
                  top: 0,
                  child: NoteEditor(
                    note: note,
                    controller: controller,
                    focusNode: focusNode,
                  )),
              Positioned(
                bottom: bottomPadding,
                left: 0,
                right: 0,
                child: Visibility(
                    visible: editing,
                    child: NoteEditorToolbar(controller: controller)),
              )
            ],
          )),
    );
  }
}