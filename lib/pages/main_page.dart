import 'package:amphi/widgets/account/account_button.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/pages/note_page.dart';
import '../channels/app_method_channel.dart';
import '../channels/app_web_channel.dart';
import '../components/draggable_page.dart';
import '../components/main/app_bar/main_view_title.dart';
import '../components/main/buttons/main_view_popupmenu_button.dart';
import '../components/main/choose_folder_dialog.dart';
import '../components/main/edit_folder_dialog.dart';
import '../components/main/floating_button/floating_folder_button.dart';
import '../components/main/floating_button/floating_note_button.dart';
import '../components/main/floating_button/floating_plus_button.dart';
import '../components/main/floating_menu/floating_menu.dart';
import '../components/main/floating_menu/floating_menu_button.dart';
import '../components/main/floating_menu/floating_menu_divider.dart';
import '../components/main/floating_search_bar.dart';
import '../components/main/list_view/note_list_view.dart';
import '../extensions/sort_extension.dart';
import '../models/app_cache_data.dart';
import '../models/app_storage.dart';
import '../models/folder.dart';
import '../models/icons.dart';
import '../models/note.dart';

import '../utils/account_utils.dart';
import 'settings_page.dart';
import 'trash_page.dart';

class MainPage extends ConsumerStatefulWidget {
  final Note folder;

  const MainPage({super.key, required this.folder});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  bool buttonRotated = false;
  // late List<dynamic> originalNoteList = AppStorage.getNoteList(widget.location);
  late List<dynamic> originalNoteList = [];

  final TextEditingController searchBarController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  void searchListener() {
    // String text = searchBarController.text;
    // if (text.isEmpty) {
    //   setState(() {
    //     appStorage.notes[widget.location] = originalNoteList;
    //   });
    // } else {
    //   setState(() {
    //     appStorage.notes[widget.location] = originalNoteList.where((item) {
    //       if (item is Note) {
    //         return item.title.toLowerCase().contains(text.toLowerCase()) || item.subtitle.toLowerCase().contains(text.toLowerCase());
    //       } else {
    //         return item.title.toLowerCase().contains(text.toLowerCase());
    //       }
    //     }).toList();
    //   });
    // }
  }

  Future<void> refresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    // AppStorage.refreshNoteList((allNotes) {
    //   setState(() {
    //     appStorage.notes[widget.location] = AppStorage.getNotes(noteList: allNotes, home: widget.location);
    //     appStorage.notes[widget.location]!.sortByOption();
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
    // appState.setMainViewState = setState;
    super.initState();
  }

  void onPopInvoked(bool value, dynamic result) {
    // if (appStorage.selectedNotes != null) {
    //   setState(() {
    //     appStorage.selectedNotes = null;
    //   });
    // } else if (buttonRotated) {
    //   setState(() {
    //     buttonRotated = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    appMethodChannel.setNavigationBarColor(Theme
        .of(context)
        .scaffoldBackgroundColor);
    // var isNotSelectingNotes = appStorage.selectedNotes == null;
    var isNotSelectingNotes = false;

    return DraggablePage(
      canPopPage: !buttonRotated && isNotSelectingNotes,
      onPopInvoked: onPopInvoked,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 310,
          automaticallyImplyLeading: false,
          leading: MainViewTitle(title: "widget.title", notesCount: 0),
          actions: isNotSelectingNotes
              ? [MainViewPopupMenuButton()]
              : <Widget>[
            IconButton(
                icon: const Icon(AppIcons.move),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ChooseFolderDialog();
                      });
                }),
            IconButton(
                icon: const Icon(AppIcons.trash),
                onPressed: () =>
                    showConfirmationDialog("@dialog_title_move_to_trash", () {
                      // setState(() {
                      //   AppStorage.moveSelectedNotesToTrash(widget.location);
                      // });
                    })),
          ],
        ),
        body: Stack(
          children: [
            Positioned(
                left: 7.5,
                top: 0,
                bottom: 0,
                right: 7.5,
                child: RefreshIndicator(
                  onRefresh: refresh,
                  child: NoteListView(
                    // noteList: AppStorage.getNoteList(widget.location),
                    noteList: [],
                    onLongPress: () {
                      // setState(() {
                      //   appStorage.selectedNotes = [];
                      // });
                    },
                    onNotePressed: (Note note) {
                      if (isNotSelectingNotes) {
                        // appState.noteEditingController.setNote(note);
                        // appState.noteEditingController.readOnly = true;
                        // appState.startDraftSave();
                        // Navigator.push(context, CupertinoPageRoute(builder: (context) {
                        //   return EditNoteView(
                        //       noteEditingController: appState.noteEditingController,
                        //       createNote: false,
                        //       onSave: (changed) {
                        //         setState(() {
                        //           note = changed;
                        //           AppStorage.getNoteList(widget.location).sortByOption();
                        //         });
                        //         changed.save();
                        //       });
                        // }));
                      }
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
                                    // AppStorage.getNoteList(widget.location).sortByOption();
                                  });
                                  changed.save();
                                });
                          });
                    },
                  ),
                )),
            FloatingFolderButton(
                showing: isNotSelectingNotes && buttonRotated,
                onPressed: () {
                  // showDialog(
                  //     context: context,
                  //     builder: (context) {
                  //       // return EditFolderDialog(
                  //       //     folder: Folder.createdFolder(widget.location),
                  //       //     onSave: (folder) {
                  //       //       AppStorage.getNoteList(widget.location).add(folder);
                  //       //       setState(() {
                  //       //         AppStorage.getNoteList(widget.location).sortByOption();
                  //       //       });
                  //       //       folder.save();
                  //       //     });
                  //     });
                }),
            FloatingNoteButton(
                showing: isNotSelectingNotes && buttonRotated,
                onPressed: () {
                  // appState.noteEditingController.setNote(Note.createdNote(widget.location));
                  // appState.noteEditingController.readOnly = false;
                  // appState.startDraftSave();
                  // Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  //   return NotePage(
                  //       noteEditingController: appState.noteEditingController,
                  //       createNote: true,
                  //       onSave: (note) {
                  //         setState(() {
                  //           note.initTitles();
                  //           AppStorage.getNoteList(widget.location).add(note);
                  //           AppStorage.getNoteList(widget.location).sortByOption();
                  //         });
                  //         note.save();
                  //       });
                  // }));
                }),
            FloatingPlusButton(
                showing: isNotSelectingNotes,
                rotated: buttonRotated,
                onPressed: () {
                  searchBarController.text = "";
                  if (focusNode.hasFocus) {
                    focusNode.unfocus();
                  }
                  setState(() {
                    buttonRotated = !buttonRotated;
                  });
                }),
            FloatingMenu(showing: buttonRotated && isNotSelectingNotes, children: [
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
              const FloatingMenuDivider(),
              FloatingMenuButton(
                  icon: AppIcons.trash,
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            barrierDismissible: true,
                            builder: (context) {
                              return const TrashPage();
                            }));
                  }),
              const FloatingMenuDivider(),
              FloatingMenuButton(
                  icon: AppIcons.settings,
                  onPressed: () {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) {
                      return const SettingsPage();
                    }));
                  }),
            ]),
            FloatingSearchBar(
                showing: isNotSelectingNotes && buttonRotated, focusNode: focusNode, textEditingController: searchBarController)
          ],
        ),
      ),
    );
  }
}
