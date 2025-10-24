import 'dart:async';

import 'package:amphi/models/app.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/methods/video_state.dart';
import 'package:notes/channels/app_method_channel.dart';
import 'package:notes/components/note_editor/note_editor.dart';
import 'package:notes/components/note_editor/note_editor_toolbar.dart';
import 'package:notes/icons/icons.dart';
import 'package:notes/models/note.dart';
import 'package:notes/pages/main/menu/side_bar.dart';
import 'package:notes/pages/main/side_bar_toggle_button.dart';

import 'package:notes/providers/editing_note_provider.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:notes/providers/selected_notes_provider.dart';
import 'package:notes/utils/document_conversion.dart';
import 'package:notes/views/notes_view.dart';

import '../../providers/providers.dart';

class WideMainPage extends ConsumerStatefulWidget {
  final String? title;

  const WideMainPage({super.key, this.title});

  @override
  ConsumerState<WideMainPage> createState() => _WideMainPageState();
}

class _WideMainPageState extends ConsumerState<WideMainPage> {
  final FocusNode focusNode = FocusNode();
  final selectionFocusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    selectionFocusNode.dispose();
    super.dispose();
  }

  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    appMethodChannel.setNavigationBarColor(Theme.of(context).scaffoldBackgroundColor);
    final wideMainPageState = ref.watch(wideMainPageStateProvider);
    final controller = ref.watch(editingNoteProvider.notifier).controller;

    final themeData = Theme.of(context);

    final selectedFolderId = ref.watch(selectedFolderProvider);

    return MouseRegion(
      onHover: (event) {
        if (App.isDesktop() && wideMainPageState.sideBarFloating) {
          if (wideMainPageState.sideBarShowing && event.position.dx >= 265) {
              ref.read(wideMainPageStateProvider.notifier).setSideBarShowing(false);
          } else if (event.position.dx <= 20) {
            ref.read(wideMainPageStateProvider.notifier).setSideBarShowing(true);
          }
        }
      },
      child: Scaffold(
        backgroundColor: themeData.cardColor,
        body: Stack(
          children: [
            AnimatedPositioned(
              left: !wideMainPageState.sideBarFloating && wideMainPageState.sideBarShowing ? wideMainPageState.sideBarWidth : 0,
              top: 0,
              bottom: 0,
              right: 0,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOutQuint,
              child: Row(
                children: [
                  SizedBox(
                    width: wideMainPageState.notesViewWidth,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              if (App.isDesktop()) ...[Expanded(child: MoveWindow())],
                              Row(
                                children: [
                                  IconButton(onPressed: () {}, icon: Icon(AppIcons.trash, size: Theme.of(context).appBarTheme.iconTheme?.size))
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16),
                            child: MouseRegion(
                              onHover: (d) {
                                focusNode.unfocus();
                                selectionFocusNode.requestFocus();
                              },
                              onExit: (d) {
                                selectionFocusNode.unfocus();
                                focusNode.requestFocus();
                              },
                              child: KeyboardListener(
                                  focusNode: selectionFocusNode,
                                  includeSemantics: false,
                                  onKeyEvent: (event) {
                                    if(event is KeyUpEvent) {
                                      ref.read(selectedNotesProvider.notifier).keyPressed = false;
                                      return;
                                    }
                                    if(event.physicalKey == PhysicalKeyboardKey.metaLeft) {
                                      ref.read(selectedNotesProvider.notifier).keyPressed = true;
                                      if(ref.watch(selectedNotesProvider) == null) {
                                        ref.read(selectedNotesProvider.notifier).startSelection();
                                      }
                                    }

                                    if(ref.read(selectedNotesProvider.notifier).keyPressed && event.physicalKey == PhysicalKeyboardKey.keyA) {
                                      // ref.read(selectedNotesProvider.notifier).
                                    }
                                  },
                                  child: NotesView(idList: ref.watch(notesProvider).idListByFolderIdNoteOnly(selectedFolderId), folder: Note(id: ""))),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.resizeColumn,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onHorizontalDragUpdate: (d) {
                        ref.read(wideMainPageStateProvider.notifier).setNotesViewWidth(wideMainPageState.notesViewWidth + d.delta.dx);
                      },
                      child: SizedBox(
                        width: 15,
                        child: VerticalDivider(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              if (App.isDesktop()) ...[Expanded(child: MoveWindow())],
                              Row(
                                children: noteEditorToolbarButtons(controller, Theme.of(context).iconTheme.size!),
                              ),
                              if (App.isDesktop()) ...[Expanded(child: MoveWindow())],
                            ],
                          ),
                        ),
                        Expanded(child: NoteEditor(note: ref.watch(editingNoteProvider).note, controller: controller, focusNode: focusNode)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SideBar(),
            SideBarToggleButton(),
          ],
        ),
      ),
    );
  }
}