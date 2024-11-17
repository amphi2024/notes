import 'package:flutter/material.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:notes/components/main/app_bar/main_view_title.dart';
import 'package:notes/components/main/buttons/account_button.dart';
import 'package:notes/components/main/buttons/main_view_popupmenu_button.dart';
import 'package:notes/components/main/choose_folder_dialog.dart';
import 'package:notes/components/main/edit_folder_dialog.dart';
import 'package:notes/components/main/list_view/note_list_view.dart';
import 'package:notes/components/main/notes_search_bar.dart';
import 'package:notes/extensions/sort_extension.dart';
import 'package:notes/methods/get_notes.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/folder.dart';
import 'package:notes/models/icons.dart';
import 'package:notes/models/note.dart';
import 'package:notes/models/note_embed_blocks.dart';
import 'package:notes/views/settings_dialog.dart';
import 'package:notes/views/trash_view_dialog.dart';

class FloatingWideMenu extends StatefulWidget {

  final bool showing;
  final void Function(Note) onNoteSelected;
  final FocusNode focusNode;
  final void Function(Note) toCreateNote;
  const FloatingWideMenu({super.key, required this.showing, required this.onNoteSelected, required this.focusNode, required this.toCreateNote});

  @override
  State<FloatingWideMenu> createState() => _FloatingWideMenuState();
}

class _FloatingWideMenuState extends State<FloatingWideMenu> {

  final TextEditingController searchBarController = TextEditingController();
  late FocusNode focusNode = widget.focusNode;
  late List<dynamic> originalNoteList = AppStorage.getNoteList(appState.history.last?.filename ?? "");

  void searchListener() {
    String location = appState.history.last?.filename ?? "";
    String text = searchBarController.text;
    if (text.isEmpty) {
      setState(() {
        AppStorage.getInstance().notes[location] = originalNoteList;
      });
    } else {
      setState(() {
        AppStorage.getInstance().notes[location] = originalNoteList.where((item) {
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

  Future<void> refresh() async {
    String location = appState.history.last?.filename ?? "";
    AppStorage.refreshNoteList((allNotes) {
      setState(() {
        AppStorage.getInstance().notes[location] = getNotes(noteList: allNotes, home: location);
        AppStorage.getInstance().notes[location]!.sortByOption();
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    String location = appState.history.last?.filename ?? "";
    double normalPosition = appSettings.dockedFloatingMenu ? 0 : 15;
    return PopScope(
      canPop: AppStorage.getInstance().selectedNotes == null && appState.history.length <= 1,
      onPopInvokedWithResult: (value, result) {
        if (AppStorage.getInstance().selectedNotes != null) {
          setState(() {
            AppStorage.getInstance().selectedNotes = null;
          });
        }
        else if(appState.history.length > 1) {
          setState(() {
            appState.history.removeLast();
          });
        }
      },
      child: AnimatedPositioned(
          left: widget.showing? normalPosition : -300,
          top: normalPosition,
          bottom: normalPosition,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOutQuint,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutQuint,
            width: 250,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius:  appSettings.dockedFloatingMenu ? BorderRadius.zero : BorderRadius.circular(15),
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: appSettings.dockedFloatingMenu ? null : [
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
                  height: 52.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(icon: Icon(Icons.arrow_back, color: location == "" ? Theme.of(context).dividerColor : null),
                          onPressed: () {
                        if(appState.history.length > 1) {
                          appState.history.removeLast();
                          appState.notifySomethingChanged(() {

                          });
                        }

                      }),
                      IconButton(icon: Icon(Icons.refresh), onPressed: () {
                        refresh();
                      }),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: MainViewTitle(
                          notesCount: AppStorage.getNoteList(location).length,
                          title: appState.history.last?.title,
                          onEditNotes: () {
                            setState(() {
                              AppStorage.getInstance().selectedNotes = [];
                            });
                      }),
                    ),
                    AppStorage.getInstance().selectedNotes == null ? MainViewPopupMenuButton() : Row(
                      children: [
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
                                AppStorage.moveSelectedNotesToTrash(location);
                              });
                            })),
                      ],
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
                  child: SizedBox(
                      height: 30,
                      child: NotesSearchBar(textEditingController: searchBarController)),
                ),
                Expanded(
                    child: NoteListView(
                      noteList: AppStorage.getNoteList(location),
                      onLongPress: () {
                        setState(() {
                          AppStorage.getInstance().selectedNotes = [];
                        });
                      },
                      onNotePressed: (note) {
                        print(note.filename);
                        noteEmbedBlocks.clear();
                        widget.onNoteSelected(note);
                      },
                      toUpdateFolder: (folder) {
                        showDialog(context: context, builder: (context) {
                          return EditFolderDialog(folder: folder, onSave: (changed) {
                            setState(() {
                              AppStorage.getInstance().selectedNotes = null;
                              folder = changed;
                              AppStorage.getNoteList(location).sortByOption();
                            });
                            changed.save();
                          });
                        });
                      },
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AccountButton(),
                    IconButton(onPressed: () {
                      showDialog(context: context, builder: (context) {
                        return TrashViewDialog();
                      });
                    }, icon: Icon(AppIcons.trash)),
                    IconButton(onPressed: () {
                      showDialog(context: context, builder: (context) {
                        return SettingsDialog();
                      });
                    }, icon: Icon(AppIcons.setting)),
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
                                        return EditFolderDialog(folder: Folder.createdFolder(location), onSave: (folder) {
                                          AppStorage.getNoteList(location).add(folder);
                                          setState(() {
                                            AppStorage.getNoteList(location).sortByOption();
                                          });
                                          folder.save();
                                        });
                                      });
                                }),
                            PopupMenuItem(
                                height: 30,
                                child: Text(AppLocalizations.of(context).get("@new_note")),
                                onTap: () {
                                  widget.toCreateNote(Note.createdNote(location));
                                }),
                          ];
                    })
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}
