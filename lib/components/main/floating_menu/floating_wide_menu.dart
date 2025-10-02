import 'dart:io';

import 'package:amphi/models/app.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:amphi/widgets/account/account_button.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/main/app_bar/main_view_title.dart';
import 'package:notes/components/main/buttons/main_view_popupmenu_button.dart';
import 'package:notes/components/main/choose_folder_dialog.dart';
import 'package:notes/components/main/edit_folder_dialog.dart';
import 'package:notes/components/main/list_view/note_list_view.dart';
import 'package:notes/components/main/notes_search_bar.dart';
import 'package:notes/extensions/sort_extension.dart';
import 'package:notes/models/app_settings.dart';

import 'package:notes/models/folder.dart';
import 'package:notes/models/icons.dart';
import 'package:notes/models/note.dart';
import 'package:notes/models/note_embed_blocks.dart';
import 'package:notes/dialogs/settings_dialog.dart';
import 'package:notes/dialogs/trash_view_dialog.dart';

import '../../../channels/app_method_channel.dart';
import '../../../channels/app_web_channel.dart';
import '../../../models/app_cache_data.dart';
import '../../../models/app_storage.dart';
import '../../../utils/account_utils.dart';

class FloatingWideMenu extends ConsumerStatefulWidget {
  final bool showing;
  final void Function(Note) onNoteSelected;
  final FocusNode focusNode;
  final void Function(Note) toCreateNote;

  const FloatingWideMenu({super.key, required this.showing, required this.onNoteSelected, required this.focusNode, required this.toCreateNote});

  @override
  ConsumerState<FloatingWideMenu> createState() => _FloatingWideMenuState();
}

class _FloatingWideMenuState extends ConsumerState<FloatingWideMenu> {
  final TextEditingController searchBarController = TextEditingController();
  late FocusNode focusNode = widget.focusNode;

  // late List<dynamic> originalNoteList = AppStorage.getNoteList(appState.history.last?.filename ?? "");
  late List<dynamic> originalNoteList = [];

  void searchListener() {
    // String location = appState.history.last?.filename ?? "";
    String location = "";
    String text = searchBarController.text;
    if (text.isEmpty) {
      // setState(() {
      //   appStorage.notes[location] = originalNoteList;
      // });
    } else {
      // setState(() {
      //   appStorage.notes[location] = originalNoteList.where((item) {
      //     if (item is Note) {
      //       return item.title.toLowerCase().contains(text.toLowerCase()) || item.subtitle.toLowerCase().contains(text.toLowerCase());
      //     } else {
      //       return item.title.toLowerCase().contains(text.toLowerCase());
      //     }
      //   }).toList();
      // });
    }
  }

  Future<void> refresh() async {
    // String location = appState.history.last?.filename ?? "";
    String location = "";
    // AppStorage.refreshNoteList((allNotes) {
    //   setState(() {
    //     appStorage.notes[location] = AppStorage.getNotes(noteList: allNotes, home: location);
    //     appStorage.notes[location]!.sortByOption();
    //   });
    // });
  }

  @override
  void dispose() {
    searchBarController.removeListener(searchListener);
    searchBarController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    searchBarController.addListener(searchListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // String location = appState.history.last?.filename ?? "";
    String location = "";
    double normalPosition = appSettings.dockedFloatingMenu ? 0 : 15;
    double top = appSettings.dockedFloatingMenu ? 0 : 15;

    List<Widget> children = [
      IconButton(
          icon: Icon(Icons.arrow_back, color: location == "" ? Theme
              .of(context)
              .dividerColor : null),
          onPressed: () {
            // if (appState.history.length > 1) {
            //   appState.history.removeLast();
            //   appState.notifySomethingChanged(() {});
            // }
          }),
      IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            refresh();
          })
    ];

    if (App.isDesktop()) {
      children.insert(0, Expanded(child: MoveWindow()));
    }

    var titleButtonsHeight = 47.5;
    if (Platform.isIOS) {
      titleButtonsHeight = 52.5;
    }
    if (Platform.isAndroid) {
      top = appSettings.dockedFloatingMenu ? 0 : 15 + MediaQuery
          .of(context)
          .padding
          .top;
      titleButtonsHeight = appSettings.dockedFloatingMenu ? 52.5 + MediaQuery
          .of(context)
          .padding
          .top : 50;
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
          left: widget.showing ? normalPosition : -300,
          top: top,
          bottom: normalPosition,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOutQuint,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutQuint,
            width: 250,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: appSettings.dockedFloatingMenu ? BorderRadius.zero : BorderRadius.circular(15),
              color: Theme
                  .of(context)
                  .scaffoldBackgroundColor,
              boxShadow: appSettings.dockedFloatingMenu
                  ? null
                  : [
                BoxShadow(
                  color: Theme
                      .of(context)
                      .shadowColor,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: children,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: MainViewTitle(
                        notesCount: 0,
                        // notesCount: AppStorage
                        //     .getNoteList(location)
                        //     .length,
                        // title: appState.history.last?.title,
                        title: "",
                      ),
                    ),
                    // appStorage.selectedNotes == null
                    //     ? MainViewPopupMenuButton()
                    //     : Row(
                    //   children: [
                    //     IconButton(
                    //         icon: const Icon(AppIcons.move),
                    //         onPressed: () {
                    //           showDialog(
                    //               context: context,
                    //               builder: (context) {
                    //                 return ChooseFolderDialog();
                    //               });
                    //         }),
                    //     IconButton(
                    //         icon: const Icon(AppIcons.trash),
                    //         onPressed: () =>
                    //             showConfirmationDialog("@dialog_title_move_to_trash", () {
                    //               // setState(() {
                    //               //   AppStorage.moveSelectedNotesToTrash(location);
                    //               // });
                    //             })),
                    //   ],
                    // ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
                  child: SizedBox(height: 30, child: NotesSearchBar(textEditingController: searchBarController)),
                ),
                Expanded(
                    child: NoteListView(
                      // noteList: AppStorage.getNoteList(location),
                      noteList: [],
                      onLongPress: () {
                        // setState(() {
                        //   appStorage.selectedNotes = [];
                        // });
                      },
                      onNotePressed: (note) {
                        noteEmbedBlocks.clear();
                        widget.onNoteSelected(note);
                      },
                      toUpdateFolder: (folder) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return EditFolderDialog(
                                  folder: folder,
                                  onSave: (changed) {
                                    setState(() {
                                      //appStorage.selectedNotes = null;
                                      folder = changed;
                                      // AppStorage.getNoteList(location).sortByOption();
                                    });
                                    changed.save();
                                  });
                            });
                      },
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AccountButton(onLoggedIn: ({required id, required token, required username}) {
                      onLoggedIn(id: id,
                          token: token,
                          username: username,
                          context: context,
                          ref: ref);
                    },
                        iconSize: 25,
                        profileIconSize: 15,
                        wideScreenIconSize: 25,
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
                          appMethodChannel.setNavigationBarColor(Theme
                              .of(context)
                              .scaffoldBackgroundColor);
                        }),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return TrashViewDialog();
                              });
                        },
                        icon: Icon(AppIcons.trash)),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return SettingsDialog();
                              });
                        },
                        icon: Icon(AppIcons.settings, size: Theme
                            .of(context)
                            .iconTheme
                            .size ?? 15 - 2.5,)),
                    PopupMenuButton(
                        icon: Icon(Icons.add_circle_outline_outlined),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                                height: 30,
                                child: Text(AppLocalizations.of(context).get("@new_folder")),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return EditFolderDialog(
                                            folder: Folder.createdFolder(location),
                                            onSave: (folder) {
                                              // AppStorage.getNoteList(location).add(folder);
                                              // setState(() {
                                              //   AppStorage.getNoteList(location).sortByOption();
                                              // });
                                              folder.save();
                                            });
                                      });
                                }),
                            PopupMenuItem(
                                height: 30,
                                child: Text(AppLocalizations.of(context).get("@new_note")),
                                onTap: () {
                                  // widget.toCreateNote(Note.createdNote(location));
                                }),
                          ];
                        })
                  ],
                )
              ],
            ),
          )),
    );
  }
}
