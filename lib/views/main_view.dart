import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/channels/app_method_channel.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:notes/components/main/app_bar/main_view_title.dart';
import 'package:notes/components/main/buttons/account_button.dart';
import 'package:notes/components/main/buttons/main_view_popupmenu_button.dart';
import 'package:notes/components/main/choose_folder_dialog.dart';
import 'package:notes/components/main/edit_folder_dialog.dart';
import 'package:notes/components/main/floating_button/floating_folder_button.dart';
import 'package:notes/components/main/floating_button/floating_note_button.dart';
import 'package:notes/components/main/floating_button/floating_plus_button.dart';
import 'package:notes/components/main/floating_menu/floating_menu.dart';
import 'package:notes/components/main/floating_menu/floating_menu_button.dart';
import 'package:notes/components/main/floating_menu/floating_menu_divider.dart';
import 'package:notes/components/main/floating_search_bar.dart';
import 'package:notes/components/main/list_view/note_list_view.dart';
import 'package:notes/extensions/sort_extension.dart';
import 'package:notes/methods/get_notes.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/folder.dart';
import 'package:notes/models/icons.dart';
import 'package:notes/models/note.dart';
import 'package:notes/views/app_view.dart';
import 'package:notes/views/edit_note_view.dart';
import 'package:notes/views/settings_view.dart';
import 'package:notes/views/trash_view.dart';

class MainView extends StatefulWidget {
  final String location;
  final String? title;

  const MainView(
      {super.key,
      this.location = "",
      this.title});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool buttonRotated = false;
  late List<dynamic> originalNoteList = AppStorage.getNoteList(widget.location);

  final TextEditingController searchBarController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  void searchListener() {
    String text = searchBarController.text;
    if (text.isEmpty) {
      setState(() {
        appStorage.notes[widget.location] = originalNoteList;
      });
    } else {
      setState(() {
        appStorage.notes[widget.location] = originalNoteList.where((item) {
          if (item is Note) {
            return item.title.toLowerCase().contains(text.toLowerCase()) ||
                item.subtitle.toLowerCase().contains(text.toLowerCase());
          } else {
            return item.title.toLowerCase().contains(text.toLowerCase());
          }
        }).toList();
      });
    }
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

  void restoreNotesFromTrash(List<dynamic> list) {}

  Future<void> refresh() async {
    AppStorage.refreshNoteList((allNotes) {
      setState(() {
        appStorage.notes[widget.location] = getNotes(noteList: allNotes, home: widget.location);
        appStorage.notes[widget.location]!.sortByOption();
      });
    });
  }

  void onPopInvoked(bool value, dynamic result) {
    if (appStorage.selectedNotes != null) {
      setState(() {
        appStorage.selectedNotes = null;
      });
    }
    else if (buttonRotated) {
      setState(() {
        buttonRotated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      appMethodChannel.setNavigationBarColor(
          Theme.of(context).scaffoldBackgroundColor,
          appSettings.transparentNavigationBar);
    }
    return AppView(
      canPopPage: !buttonRotated && appStorage.selectedNotes == null,
      onPopInvoked: onPopInvoked,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 310,
          automaticallyImplyLeading: false,
          leading: MainViewTitle(title: widget.title, notesCount:  (AppStorage.getNoteList(widget.location)).length),
          actions: appStorage.selectedNotes == null
              ? [
                  MainViewPopupMenuButton()
                ]
              : <Widget> [
                  IconButton(
                      icon: const Icon(AppIcons.move),
                      onPressed: ()  {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ChooseFolderDialog();
                            });
                      }),
                  IconButton(
                      icon: const Icon(AppIcons.trash),
                      onPressed: () => showConfirmationDialog(
                              "@dialog_title_move_to_trash", () {
                        setState(() {
                          AppStorage.moveSelectedNotesToTrash(widget.location);
                        });
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
                    key: GlobalKey<RefreshIndicatorState>(),
                 //   triggerMode: RefreshIndicatorTriggerMode.anywhere,
                    onRefresh: refresh,
                    child: NoteListView(
                      noteList:  AppStorage.getNoteList(widget.location),
                      onLongPress: () {
                        setState(() {
                          AppStorage.getInstance().selectedNotes = [];
                        });
                      },
                      onNotePressed: (Note note) {
                        print(note.filename);
                        if(AppStorage.getInstance().selectedNotes == null) {
                          appState.noteEditingController.setNote(note);
                          appState.noteEditingController.readOnly = true;
                          Navigator.push(context, CupertinoPageRoute(builder: (context) {
                            return EditNoteView(
                              createNote: false,
                                onSave: (changed) {
                                  setState(() {
                                    note = changed;
                                    AppStorage.getNoteList(widget.location).sortByOption();
                                  });
                                  changed.save();
                                });
                          }));
                        }
                      },
                      toUpdateFolder: (folder) {
                        showDialog(context: context, builder: (context) {
                          return EditFolderDialog(folder: folder, onSave: (changed) {
                            setState(() {
                              AppStorage.getInstance().selectedNotes = null;
                              folder = changed;
                              AppStorage.getNoteList(widget.location).sortByOption();
                            });
                            changed.save();
                          });
                        });
                      },
                    ))),
            FloatingFolderButton(
                showing: AppStorage.getInstance().selectedNotes == null && buttonRotated,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return EditFolderDialog(folder: Folder.createdFolder(widget.location), onSave: (folder) {
                          AppStorage.getNoteList(widget.location).add(folder);
                          setState(() {
                            AppStorage.getNoteList(widget.location).sortByOption();
                          });
                          folder.save();
                        });
                      });
                }),
            FloatingNoteButton(
                showing: AppStorage.getInstance().selectedNotes == null && buttonRotated,
                onPressed: () {
                  appState.noteEditingController.setNote(Note.createdNote(widget.location));
                  appState.noteEditingController.readOnly = false;
                  Navigator.push(context, CupertinoPageRoute(builder: (context) {
                    return EditNoteView(
                      createNote: true,
                        onSave: (note) {
                      setState(() {
                        note.initTitles();
                        AppStorage.getNoteList(widget.location).add(note);
                        AppStorage.getNoteList(widget.location).sortByOption();
                      });
                     note.save();
                    });
                  }));
                               }),
            FloatingPlusButton(
                showing: AppStorage.getInstance().selectedNotes == null,
                rotated: buttonRotated,
                onPressed: () {
                  searchBarController.text = "";
                  if(focusNode.hasFocus) {
                    focusNode.unfocus();
                  }
                  setState(() {
                    buttonRotated = !buttonRotated;
                  });
                }),
            FloatingMenu(
                showing: buttonRotated &&  AppStorage.getInstance().selectedNotes == null,
                children: [
                  AccountButton(),
              const FloatingMenuDivider(),
              FloatingMenuButton(
                  icon: AppIcons.trash,
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            barrierDismissible: true,
                            builder: (context) {
                              return TrashView();
                            }));
                  }),
              const FloatingMenuDivider(),
              FloatingMenuButton(
                  icon: AppIcons.setting,
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) {
                      return SettingsView();
                    }));
                  }),
            ]),
            FloatingSearchBar(
                showing:  AppStorage.getInstance().selectedNotes == null && buttonRotated,
                focusNode: focusNode,
                textEditingController: searchBarController),
          ],
        ),
      ),
    );
  }
}
