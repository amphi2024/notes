import 'dart:io';

import 'package:amphi/models/app.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/channels/app_method_channel.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/components/note_editor/note_editor.dart';
import 'package:notes/components/note_editor/note_editor_toolbar.dart';
import 'package:notes/components/notes_view_sort_menu.dart';
import 'package:notes/icons/icons.dart';
import 'package:notes/models/app_cache_data.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/note.dart';
import 'package:notes/pages/main/menu/side_bar.dart';
import 'package:notes/pages/main/side_bar_toggle_button.dart';

import 'package:notes/providers/editing_note_provider.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:notes/providers/selected_notes_provider.dart';
import 'package:notes/utils/generate_id.dart';
import 'package:notes/utils/toast.dart';
import 'package:notes/views/notes_view.dart';

import '../../components/custom_window_button.dart';
import '../../dialogs/edit_folder_dialog.dart';
import '../../models/sort_option.dart';
import '../../providers/providers.dart';
import '../../utils/note_item_press_callback.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (appSettings.useOwnServer && appWebChannel.uploadBlocked) {
        showToast(context, "upload block message");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    appMethodChannel.setNavigationBarColor(Theme.of(context).cardColor);
    final wideMainPageState = ref.watch(wideMainPageStateProvider);
    final controller = ref.watch(editingNoteProvider.notifier).controller;

    final themeData = Theme.of(context);

    final selectedFolderId = ref.watch(selectedFolderProvider);

    final colors = CustomWindowButtonColors(
        iconMouseOver: Theme.of(context).textTheme.bodyMedium?.color,
        mouseOver: const Color.fromRGBO(125, 125, 125, 0.1),
        iconNormal: Theme.of(context).textTheme.bodyMedium?.color,
        mouseDown: const Color.fromRGBO(125, 125, 125, 0.1),
        iconMouseDown: Theme.of(context).textTheme.bodyMedium?.color,
        normal: Theme.of(context).cardColor);

    final double macosPadding = Platform.isMacOS ? 75 : 0;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {},
      child: MouseRegion(
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
                            height: 55,
                            child: Row(
                              children: [
                                AnimatedPadding(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeOutQuint,
                                  padding: wideMainPageState.sideBarShowing && !wideMainPageState.sideBarFloating
                                      ? EdgeInsets.zero
                                      : EdgeInsets.only(left: 45 + macosPadding),
                                  child: PopupMenuButton(
                                      icon: Icon(
                                        AppIcons.linear,
                                        size: Theme.of(context).appBarTheme.iconTheme?.size,
                                      ),
                                      itemBuilder: (context) {
                                        return [
                                          notesViewSortMenuSortButton(
                                              context: context,
                                              label: AppLocalizations.of(context).get("@title"),
                                              folderId: selectedFolderId,
                                              sortOption: SortOption.title,
                                              sortOptionDescending: SortOption.titleDescending,
                                              ref: ref),
                                          notesViewSortMenuSortButton(
                                              context: context,
                                              label: AppLocalizations.of(context).get("@created_date"),
                                              folderId: selectedFolderId,
                                              sortOption: SortOption.created,
                                              sortOptionDescending: SortOption.createdDescending,
                                              ref: ref),
                                          notesViewSortMenuSortButton(
                                              context: context,
                                              label: AppLocalizations.of(context).get("@modified_date"),
                                              folderId: selectedFolderId,
                                              sortOption: SortOption.modified,
                                              sortOptionDescending: SortOption.modifiedDescending,
                                              ref: ref)
                                        ];
                                      }),
                                ),
                                if (App.isDesktop()) ...[Expanded(child: MoveWindow())],
                                PopupMenuButton(
                                    icon: Icon(Icons.add_circle_outline),
                                    iconSize: Theme.of(context).appBarTheme.iconTheme?.size,
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem(
                                            height: 30,
                                            child: Text(AppLocalizations.of(context).get("@new_note")),
                                            onTap: () async {
                                              saveEditingNoteBeforeSwitch(ref);
                                              ref.read(selectedNotesProvider.notifier).endSelection();

                                              var note = Note(id: await generatedNoteId());
                                              note.created = DateTime.now();
                                              note.parentId = selectedFolderId;
                                              prepareEmbeddedBlocks(ref, note);

                                              ref.read(editingNoteProvider.notifier).startEditing(note, true);
                                              ref.read(editingNoteProvider.notifier).initController(ref);

                                              ref.read(notesProvider.notifier).insertNote(note);
                                            }),
                                        PopupMenuItem(
                                            height: 30,
                                            child: Text(AppLocalizations.of(context).get("@new_folder")),
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    var folder = Note(id: "");
                                                    folder.parentId = selectedFolderId;
                                                    folder.isFolder = true;
                                                    return EditFolderDialog(folder: folder, ref: ref);
                                                  });
                                            })
                                      ];
                                    }),
                                IconButton(
                                    onPressed: () async {
                                      final selectedNotes = ref.watch(selectedNotesProvider);
                                      if (selectedNotes != null) {
                                        if (selectedFolderId == "!TRASH") {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return ConfirmationDialog(
                                                    title: AppLocalizations.of(context).get("@dialog_title_delete_selected_notes"),
                                                    onConfirmed: () {
                                                      for (var id in selectedNotes) {
                                                        final note = ref.watch(notesProvider).notes.get(id);
                                                        note.delete(ref: ref);
                                                      }
                                                      ref.read(notesProvider.notifier).deleteNotes(selectedNotes);
                                                      ref.read(selectedNotesProvider.notifier).endSelection();
                                                    });
                                              });
                                        } else {
                                          ref.read(notesProvider.notifier).moveNotes(selectedNotes, selectedFolderId, "!TRASH");
                                          ref.read(selectedNotesProvider.notifier).endSelection();

                                          for (var id in selectedNotes) {
                                            final note = ref.watch(notesProvider).notes.get(id);
                                            note.deleted = DateTime.now();
                                            note.save();
                                          }
                                        }
                                      }
                                    },
                                    icon: Icon(AppIcons.trash, size: Theme.of(context).appBarTheme.iconTheme?.size))
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
                                      if (event is KeyUpEvent) {
                                        ref.read(selectedNotesProvider.notifier).keyPressed = false;
                                        return;
                                      }
                                      if (event.physicalKey == PhysicalKeyboardKey.metaLeft || event.physicalKey == PhysicalKeyboardKey.controlLeft) {
                                        ref.read(selectedNotesProvider.notifier).keyPressed = true;
                                        if (ref.watch(selectedNotesProvider) == null) {
                                          ref.read(selectedNotesProvider.notifier).startSelection();
                                        }
                                      }

                                      if (ref.read(selectedNotesProvider.notifier).keyPressed && event.physicalKey == PhysicalKeyboardKey.keyA) {
                                        // ref.read(selectedNotesProvider.notifier).
                                      }
                                    },
                                    child:
                                        NotesView(idList: ref.watch(notesProvider).idListByFolderIdNoteOnly(selectedFolderId), folder: Note(id: ""))),
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
                        onHorizontalDragEnd: (d) {
                          appCacheData.sidebarWidth = wideMainPageState.sideBarWidth;
                          appCacheData.notesViewWidth = wideMainPageState.notesViewWidth;
                          appCacheData.save();
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
                            height: 55,
                            child: Row(
                              children: [
                                if (App.isDesktop()) ...[Expanded(child: MoveWindow())],
                                Row(
                                  children: noteEditorToolbarButtons(controller, Theme.of(context).appBarTheme.iconTheme!.size!),
                                ),
                                if (App.isDesktop()) ...[Expanded(child: MoveWindow())],
                                if (Platform.isWindows) ...[
                                  Visibility(
                                    visible: App.isDesktop(),
                                    child: MinimizeCustomWindowButton(colors: colors),
                                  ),
                                  appWindow.isMaximized
                                      ? RestoreCustomWindowButton(
                                          colors: colors,
                                          onPressed: () {
                                            appWindow.restore();
                                          },
                                        )
                                      : MaximizeCustomWindowButton(
                                          colors: colors,
                                          onPressed: () {
                                            appWindow.maximize();
                                          },
                                        ),
                                  CloseCustomWindowButton(
                                      colors: CustomWindowButtonColors(
                                          mouseOver: const Color(0xFFD32F2F),
                                          mouseDown: const Color(0xFFB71C1C),
                                          iconNormal: const Color(0xFF805306),
                                          iconMouseOver: const Color(0xFFFFFFFF),
                                          normal: Theme.of(context).cardColor))
                                ],
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
      ),
    );
  }
}
