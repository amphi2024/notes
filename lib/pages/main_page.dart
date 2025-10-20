import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/main_page_app_bar.dart';
import 'package:notes/providers/editing_note_provider.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:notes/providers/providers.dart';
import 'package:notes/providers/selected_notes_provider.dart';
import 'package:notes/utils/generate_id.dart';
import '../channels/app_method_channel.dart';
import '../components/draggable_page.dart';
import '../components/main/edit_folder_dialog.dart';
import '../components/main_page_title.dart';
import '../components/floating_button.dart';
import '../components/main/floating_search_bar.dart';
import '../components/titled_floating_button.dart';
import '../components/main/floating_menu/floating_menu.dart';
import '../providers/tables_provider.dart';
import '../services/audio_service.dart';
import '../services/videos_service.dart';
import '../views/notes_view.dart';
import '../icons/icons.dart';
import '../models/note.dart';
import 'note_page.dart';

class MainPage extends ConsumerStatefulWidget {
  final Note folder;

  const MainPage({super.key, required this.folder});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    appMethodChannel
        .setNavigationBarColor(Theme.of(context).scaffoldBackgroundColor);

    final selectedNotes = ref.watch(selectedNotesProvider);
    final selectingNotes = selectedNotes != null;
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
          return;
        }
        if (buttonRotated) {
          ref.read(floatingButtonStateProvider.notifier).setRotated(false);
          return;
        }
        ref.read(notesProvider).releaseNotes(widget.folder.id);
      },
      child: Scaffold(
          appBar: AppBar(
            leadingWidth: 310,
            automaticallyImplyLeading: false,
            leading: MainPageTitle(
                title: widget.folder.id.isEmpty
                    ? AppLocalizations.of(context).get("@notes")
                    : widget.folder.title,
                notesCount: ref.watch(notesProvider).idListByFolderId(widget.folder.id).length),
            actions: appbarActions(context: context, selectedNotes: selectedNotes, ref: ref, folder: widget.folder),
          ),
          body: Stack(children: [
            Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                right: 16,
                child: NotesView(
                  folder: widget.folder,
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
                  showDialog(
                      context: context,
                      builder: (context) {
                        var folder = Note(id: "");
                        folder.parentId = widget.folder.id;
                        folder.isFolder = true;
                        return EditFolderDialog(folder: folder, ref: ref);
                      });
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
                  onPressed: () async {
                    var note = Note(id: await generatedNoteId());
                    note.created = DateTime.now();
                    note.parentId = widget.folder.id;
                    videosService.noteId = note.id;
                    audioService.noteId = note.id;
                    ref.read(editingNoteProvider.notifier).startEditing(note, true);
                    await Navigator.push(context, CupertinoPageRoute(builder: (context) {
                      return NotePage();
                    }));
                    ref.read(tablesProvider.notifier).clear();
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
                    if(focusNode.hasFocus) {
                      focusNode.unfocus();
                    }
                    ref
                        .read(floatingButtonStateProvider.notifier)
                        .setRotated(!buttonRotated);
                  },
                ),
              ),
            ),
            const FloatingMenu(),
            FloatingSearchBar(focusNode: focusNode)
          ])),
    );
  }
}
