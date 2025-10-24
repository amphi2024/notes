import 'dart:io';

import 'package:amphi/models/app.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/providers/providers.dart';
import 'package:notes/models/app_settings.dart';

import 'package:notes/icons/icons.dart';
import 'package:notes/models/note.dart';

import '../../../components/items/folder_wide_screen_item.dart';
import '../../../providers/notes_provider.dart';
import '../../../utils/data_sync.dart';

class SideBar extends ConsumerStatefulWidget {
  const SideBar({super.key});

  @override
  ConsumerState<SideBar> createState() => _FloatingWideMenuState();
}

class _FloatingWideMenuState extends ConsumerState<SideBar> {
  final TreeSliverController controller = TreeSliverController();
  Map<String, bool> expandedNodes = {"" : true};

  Future<void> refresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    refreshDataWithServer(ref);
  }

  @override
  Widget build(BuildContext context) {
    // String location = appState.history.last?.filename ?? "";
    final wideMainPageState = ref.watch(wideMainPageStateProvider);
    double normalPosition = !wideMainPageState.sideBarFloating ? 0 : 15;
    double top = !wideMainPageState.sideBarFloating ? 0 : 15;

    var titleButtonsHeight = 47.5;
    if (Platform.isIOS) {
      titleButtonsHeight = 52.5;
    }
    if (Platform.isAndroid) {
      top = appSettings.dockedFloatingMenu ? 0 : 15 + MediaQuery.of(context).padding.top;
      titleButtonsHeight = appSettings.dockedFloatingMenu ? 52.5 + MediaQuery.of(context).padding.top : 50;
    }

    return PopScope(
      // canPop: appStorage.selectedNotes == null && appState.history.length <= 1,
      onPopInvokedWithResult: (value, result) {
        // if (appStorage.selectedNotes != null) {
        //   setState(() {
        //     appStorage.selectedNotes = null;
        //   });
        // } else if (appState.history.length > 1) {
        //   setState(() {
        //     appState.history.removeLast();
        //   });
        // }
      },
      child: AnimatedPositioned(
          left: wideMainPageState.sideBarShowing ? normalPosition : -wideMainPageState.sideBarWidth - 100,
          top: top,
          bottom: normalPosition,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOutQuint,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutQuint,
            width: wideMainPageState.sideBarWidth,
            decoration: BoxDecoration(
              borderRadius: appSettings.dockedFloatingMenu ? BorderRadius.zero : BorderRadius.circular(15),
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: appSettings.dockedFloatingMenu
                  ? null
                  : [
                      BoxShadow(
                        color: Theme.of(context).shadowColor,
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: titleButtonsHeight,
                  // child: Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   crossAxisAlignment: CrossAxisAlignment.end,
                  //   children: children,
                  // ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomScrollView(
                      slivers: <Widget>[
                        TreeSliver<Note>(
                          tree: _tree(ref: ref, context: context, expandedNodes: expandedNodes),
                          controller: controller,
                          toggleAnimationStyle: AnimationStyle(
                            curve: Curves.easeOutQuint
                          ),
                          indentation: TreeSliverIndentationType.none,
                          treeNodeBuilder: (
                            BuildContext context,
                            TreeSliverNode<Object?> node,
                            AnimationStyle animationStyle,
                          ) {
                            final note = node.content as Note;

                            final idList =
                                note.id == "!TRASH" ? ref.watch(notesProvider).trashNoteOnly() : ref.watch(notesProvider).idListByFolderIdNoteOnly(note.id);

                            return FolderWideScreenItem(
                              key: Key(note.id),
                                folder: note,
                                iconVisible: node.children.isNotEmpty,
                                onPressed: () {
                                  ref.read(selectedFolderProvider.notifier).setFolderId(note.id);
                                },
                                onIconPressed: () {
                                  if(node.isExpanded) {
                                    expandedNodes[note.id] = false;
                                    controller.collapseNode(node);
                                  }
                                  else {
                                    expandedNodes[note.id] = true;
                                    controller.expandNode(node);
                                  }
                                },
                                expanded: node.isExpanded,
                                indent: (node.depth ?? 0) * 8,
                                itemCount: idList.length);
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

List<TreeSliverNode<Note>> _tree({required WidgetRef ref, required BuildContext context, required Map<String, bool> expandedNodes}) {
  return [
    TreeSliverNode<Note>(Note(id: "", title: AppLocalizations.of(context).get("@notes"), ),
        children: _treeChildren(ref: ref, context: context, parentId: "", expandedNodes: expandedNodes), expanded: expandedNodes[""] == true),
    TreeSliverNode<Note>(Note(id: "!TRASH", title: AppLocalizations.of(context).get("@trash")), expanded: expandedNodes["!TRASH"] == true)
  ];
}

List<TreeSliverNode<Note>>? _treeChildren({required WidgetRef ref, required BuildContext context, required String parentId, required Map<String, bool> expandedNodes}) {
  final idList = ref.watch(notesProvider).idListByFolderIdFolderOnly(parentId);

  if (idList.isEmpty) {
    return null;
  }

  final List<TreeSliverNode<Note>> list = [];

  for (var id in idList) {
    final note = ref.read(notesProvider).notes.get(id);
    list.add(TreeSliverNode<Note>(Note(id: id, title: note.title),
        expanded: expandedNodes[id] == true,
        children: _treeChildren(ref: ref, context: context, parentId: note.id, expandedNodes: expandedNodes)));
  }

  return list;
}
