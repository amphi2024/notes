import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/channels/app_method_channel.dart';
import 'package:notes/components/note_editor/note_editor_toolbar.dart';
import 'package:notes/components/note_editor/note_editor.dart';
import 'package:notes/components/note_page_app_bar.dart';
import 'package:notes/icons/icons.dart';
import 'package:notes/models/note.dart';
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
      // document: Document.fromDelta(note.delta),
      selection: TextSelection(baseOffset: 0, extentOffset: 0));
  Timer? timer;
  // late final note = ref.read(editingNoteProvider).note;

  @override
  void dispose() {
    noteEmbedBlocks.clear();
    controller.dispose();
    timer?.cancel();
    // note.content = controller.document.toNoteContent();
    // note.modified = DateTime.now();
    //note.save();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.document.changes.listen((data) {
        timer?.cancel();
        timer = Timer(Duration(seconds: 2), () async {
          final note = ref.watch(editingNoteProvider).note;
          note.content = controller.document.toNoteContent();
          note.modified = DateTime.now();
          note.save();
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
          note.content = controller.document.toNoteContent();
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
                  // if (ref.watch(editingNoteProvider).note.id.isNotEmpty &&
                  //     !controller.readOnly) {
                  //   setState(() {
                  //     controller.document = originalNote.contentToDocument();
                  //     controller.readOnly = true;
                  //   });
                  // } else {
                  //   Navigator.pop(context);
                  // }
                  Navigator.pop(context);
                },
                icon: const Icon(AppIcons.back, size: 25)),
            actions: notePageAppbarActions(context: context, ref: ref, note: note, controller: controller, editing: editing),
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
