import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:notes/providers/providers.dart';
import 'package:notes/providers/selected_notes_provider.dart';
import 'package:notes/utils/data_sync.dart';
import '../channels/app_method_channel.dart';
import '../components/draggable_page.dart';
import '../components/main/app_bar/main_view_title.dart';
import '../components/main/buttons/main_view_popupmenu_button.dart';
import '../components/main/choose_folder_dialog.dart';
import '../components/floating_button.dart';
import '../components/main/floating_search_bar.dart';
import '../components/titled_floating_button.dart';
import '../components/main/floating_menu/floating_menu.dart';
import '../views/notes_view.dart';
import '../models/icons.dart';
import '../models/note.dart';

class MainPage extends ConsumerStatefulWidget {
  final Note folder;

  const MainPage({super.key, required this.folder});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {

  Future<void> refresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    refreshDataWithServer(ref);
  }

  @override
  void initState() {
    //ref.read(notesProvider).loadChildren(widget.folder.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appMethodChannel
        .setNavigationBarColor(Theme.of(context).scaffoldBackgroundColor);
    final selectingNotes = ref.watch(selectedNotesProvider) != null;
    final buttonRotated = ref.watch(floatingButtonStateProvider);
    var bottomPadding = MediaQuery.of(context).padding.bottom;
    if (bottomPadding == 0) {
      bottomPadding = 15;
    }

    return DraggablePage(
      canPopPage: !buttonRotated && !selectingNotes,
      onPopInvoked: (value, result) {
        if (selectingNotes) {
          ref.read(selectedNotesProvider.notifier).endSelection();
        }
        if (buttonRotated) {
          ref.read(floatingButtonStateProvider.notifier).setRotated(false);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            leadingWidth: 310,
            automaticallyImplyLeading: false,
            leading: MainViewTitle(
                title: widget.folder.id.isEmpty
                    ? AppLocalizations.of(context).get("@notes")
                    : widget.folder.title,
                notesCount: 0),
            actions: selectingNotes
                ? <Widget>[
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
                        onPressed: () => showConfirmationDialog(
                                "@dialog_title_move_to_trash", () {
                              // setState(() {
                              //   AppStorage.moveSelectedNotesToTrash(widget.location);
                              // });
                            })),
                  ]
                : [MainViewPopupMenuButton()],
          ),
          body: Stack(children: [
            Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                right: 16,
                child: NotesView(
                  idList: ref
                      .watch(notesProvider)
                      .idListByFolderId(widget.folder.id)
                )),
            AnimatedPositioned(
              duration: Duration(
                  milliseconds: !selectingNotes && buttonRotated ? 1250 : 1000),
              curve: Curves.easeOutQuint,
              right: !selectingNotes && buttonRotated ? 20 : -160,
              bottom: bottomPadding + 155,
              child: TitledFloatingButton(
                title: AppLocalizations.of(context).get("@folder"),
                icon: AppIcons.folder,
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
                },
              ),
            ),
            AnimatedPositioned(
                duration: Duration(milliseconds: selectingNotes ? 1250 : 1000),
                curve: Curves.easeOutQuint,
                right: !selectingNotes && buttonRotated ? 20 : -160,
                bottom: bottomPadding + 80,
                child: TitledFloatingButton(
                  icon: AppIcons.note,
                  title: AppLocalizations.of(context).get("@note"),
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
                  },
                )),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 750),
              curve: Curves.easeOutQuint,
              right: selectingNotes ? -120 : 20,
              bottom: bottomPadding + 5,
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 1250),
                curve: Curves.easeOutQuint,
                turns: buttonRotated ? -0.125 : 0,
                child: FloatingButton(
                  icon: AppIcons.plus,
                  onPressed: () {
                    ref
                        .read(floatingButtonStateProvider.notifier)
                        .setRotated(!buttonRotated);
                  },
                ),
              ),
            ),
            const FloatingMenu(),
            const FloatingSearchBar()
          ])),
    );
  }
}
