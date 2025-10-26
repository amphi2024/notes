import 'package:amphi/models/app.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/widgets/account/account_button.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/channels/app_method_channel.dart';
import 'package:notes/providers/providers.dart';
import 'package:notes/models/app_settings.dart';

import 'package:notes/models/note.dart';

import '../../../channels/app_web_channel.dart';
import '../../../components/items/folder_wide_screen_item.dart';
import '../../../models/app_cache_data.dart';
import '../../../models/app_storage.dart';
import '../../../providers/notes_provider.dart';
import '../../../utils/account_utils.dart';
import '../../../utils/data_sync.dart';

class SideBar extends ConsumerStatefulWidget {
  const SideBar({super.key});

  @override
  ConsumerState<SideBar> createState() => _FloatingWideMenuState();
}

class _FloatingWideMenuState extends ConsumerState<SideBar> {
  final TreeSliverController controller = TreeSliverController();
  Map<String, bool> expandedNodes = {"": true};

  Future<void> refresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    refreshDataWithServer(ref);
  }

  @override
  Widget build(BuildContext context) {
    final wideMainPageState = ref.watch(wideMainPageStateProvider);
    double normalPosition = !wideMainPageState.sideBarFloating ? 0 : 15;
    double top = !wideMainPageState.sideBarFloating ? 0 : 15;

    return AnimatedPositioned(
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
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if(App.isDesktop()) ... [
                          Expanded(child: SizedBox(
                              height: 55,
                              child: MoveWindow()))
                        ],
                        AccountButton(
                            onLoggedIn: ({required id, required token, required username}) {
                              onLoggedIn(id: id, token: token, username: username, context: context, ref: ref);
                            },
                            iconSize: Theme.of(context).appBarTheme.iconTheme!.size!,
                            profileIconSize: Theme.of(context).appBarTheme.iconTheme!.size!,
                            wideScreenIconSize: Theme.of(context).appBarTheme.iconTheme!.size!,
                            wideScreenProfileIconSize: 15,
                            appWebChannel: appWebChannel,
                            appStorage: appStorage,
                            appCacheData: appCacheData,
                            onUserRemoved: () {
                              onUserRemoved(ref);
                            },
                            onUserAdded: () {
                              onUserAdded(ref);
                            },
                            onUsernameChanged: () {
                              onUsernameChanged(ref);
                            },
                            onSelectedUserChanged: (user) {
                              onSelectedUserChanged(user, ref);
                            },
                            setAndroidNavigationBarColor: () {
                              appMethodChannel.setNavigationBarColor(Theme.of(context).scaffoldBackgroundColor);
                            })
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomScrollView(
                          slivers: <Widget>[
                            TreeSliver<Note>(
                              tree: _tree(ref: ref, context: context, expandedNodes: expandedNodes),
                              controller: controller,
                              toggleAnimationStyle: AnimationStyle(curve: Curves.easeOutQuint),
                              indentation: TreeSliverIndentationType.none,
                              treeNodeBuilder: (
                                BuildContext context,
                                TreeSliverNode<Object?> node,
                                AnimationStyle animationStyle,
                              ) {
                                final note = node.content as Note;

                                final idList = ref.watch(notesProvider).idListByFolderIdNoteOnly(note.id);

                                return FolderWideScreenItem(
                                    key: Key(note.id),
                                    folder: note,
                                    iconVisible: node.children.isNotEmpty,
                                    onPressed: () {
                                      ref.read(selectedFolderProvider.notifier).setFolderId(note.id);
                                    },
                                    onIconPressed: () {
                                      if (node.isExpanded) {
                                        expandedNodes[note.id] = false;
                                        controller.collapseNode(node);
                                        ref.read(notesProvider).releaseNotes(note.id);
                                      } else {
                                        expandedNodes[note.id] = true;
                                        controller.expandNode(node);
                                        ref.read(notesProvider).preloadNotes(note.id);
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
              ),
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeColumn,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragUpdate: (d) {
                      ref.read(wideMainPageStateProvider.notifier).setSideBarWidth(wideMainPageState.sideBarWidth + d.delta.dx);
                    },
                    child: SizedBox(
                      width: 5,
                      child: VerticalDivider(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

List<TreeSliverNode<Note>> _tree({required WidgetRef ref, required BuildContext context, required Map<String, bool> expandedNodes}) {
  return [
    TreeSliverNode<Note>(
        Note(
          id: "",
          title: AppLocalizations.of(context).get("@notes"),
        ),
        children: _treeChildren(ref: ref, context: context, parentId: "", expandedNodes: expandedNodes),
        expanded: expandedNodes[""] == true),
    TreeSliverNode<Note>(Note(id: "!TRASH", title: AppLocalizations.of(context).get("@trash")),
        children: _treeChildren(ref: ref, context: context, parentId: "!TRASH", expandedNodes: expandedNodes),
        expanded: expandedNodes["!TRASH"] == true)
  ];
}

List<TreeSliverNode<Note>>? _treeChildren(
    {required WidgetRef ref, required BuildContext context, required String parentId, required Map<String, bool> expandedNodes}) {
  final idList = ref.watch(notesProvider).idListByFolderIdFolderOnly(parentId);

  if (idList.isEmpty) {
    return null;
  }

  final List<TreeSliverNode<Note>> list = [];

  for (var id in idList) {
    final note = ref.read(notesProvider).notes.get(id);
    list.add(TreeSliverNode<Note>(Note(id: id, title: note.title),
        expanded: expandedNodes[id] == true, children: _treeChildren(ref: ref, context: context, parentId: note.id, expandedNodes: expandedNodes)));
  }

  return list;
}