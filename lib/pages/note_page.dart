
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


class NotePage extends ConsumerStatefulWidget {
  const NotePage({super.key});

  @override
  ConsumerState<NotePage> createState() => _NotePageState();
}

class _NotePageState extends ConsumerState<NotePage> {
  late final Note originalNote;
  late final controller = QuillController(
      document: ref.watch(editingNoteProvider).document,
      selection: TextSelection(baseOffset: 0, extentOffset: 0),
      readOnly: ref.watch(editingNoteProvider).id.isNotEmpty);

  @override
  void dispose() {
    noteEmbedBlocks.clear();
    controller.dispose();
    // appState.draftSaveTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      originalNote = ref.read(editingNoteProvider);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final note = ref.watch(editingNoteProvider);
    appMethodChannel
        .setNavigationBarColor(note.backgroundColorByTheme(context));
    return PopScope(
      canPop: controller.readOnly || ref.watch(editingNoteProvider).id.isEmpty,
      onPopInvokedWithResult: (didPop, result) {
        if (ref.watch(editingNoteProvider).id.isNotEmpty &&
            !controller.readOnly) {
          setState(() {
            controller.document = originalNote.contentToDocument();
            controller.readOnly = true;
          });
        }
      },
      child: Scaffold(
          backgroundColor: note.backgroundColorByTheme(context),
          appBar: AppBar(
            backgroundColor: note.backgroundColorByTheme(context),
            leading: IconButton(
                onPressed: () {
                  if (ref.watch(editingNoteProvider).id.isNotEmpty &&
                      !controller.readOnly) {
                    setState(() {
                      controller.document = originalNote.contentToDocument();
                      controller.readOnly = true;
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(AppIcons.back, size: 25)),
            actions: notePageAppbarActions(context: context, ref: ref, note: note, controller: controller),
          ),
          body: Stack(
            children: [
              Positioned(
                  left: 10,
                  right: 10,
                  bottom: controller.readOnly ? 0 : 60,
                  top: 0,
                  child: NoteEditor(
                    note: note,
                    controller: controller,
                  )),
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom,
                left: 0,
                right: 0,
                child: Visibility(
                    visible: !controller.readOnly,
                    child: NoteEditorToolbar(controller: controller)),
              )
            ],
          )),
    );
  }
}
