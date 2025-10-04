import 'package:amphi/models/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/components/main/list_view/folder_grid_item.dart';
import 'package:notes/components/main/list_view/folder_linear_item.dart';
import 'package:notes/components/main/list_view/linear_item_border.dart';
import 'package:notes/components/main/list_view/note_grid_item.dart';
import 'package:notes/components/main/list_view/note_linear_item.dart';
import 'package:notes/models/app_settings.dart';

import 'package:notes/models/folder.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/notes_provider.dart';

class NotesView extends ConsumerStatefulWidget {
  final List<String> idList;

  const NotesView({super.key, required this.idList});

  @override
  ConsumerState<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends ConsumerState<NotesView>
    with AutomaticKeepAliveClientMixin<NotesView> {
  // ScrollController scrollController = ScrollController(initialScrollOffset: appState.noteListScrollPosition);
  ScrollController scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      // appState.noteListScrollPosition = scrollController.position.pixels;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final notes = ref
        .watch(notesProvider)
        .notes;
    final idList = widget.idList;
    // if (appSettings.viewMode == "linear") {
    //
    // } else {
    //   return LayoutBuilder(builder: (context, constraints) {
    //     double width = constraints.maxWidth;
    //     int axisCount = (width / 150).toInt();
    //     return MasonryGridView.builder(
    //       controller: scrollController,
    //       itemCount: widget.idList.length,
    //       gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: axisCount),
    //       itemBuilder: (context, index) {
    //         if (widget.idList[index] is Folder) {
    //           return FolderGridItem(
    //             onPressed: () => onFolderPressed(widget.idList[index]),
    //             onLongPress: widget.onLongPress,
    //             folder: widget.idList[index] as Folder,
    //             toUpdateFolder: () {
    //               widget.toUpdateFolder(widget.idList[index]);
    //             },
    //           );
    //         } else {
    //           return NoteGridItem(
    //               onPressed: () => widget.onNotePressed(widget.idList[index]),
    //               onLongPress: widget.onLongPress,
    //               note: widget.idList[index] as Note);
    //         }
    //       },
    //     );
    //   });
    // }
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      controller: scrollController,
      itemCount: idList.length,
      itemBuilder: (context, index) {
        LinearItemBorder border = LinearItemBorder(
            index: index, length: idList.length, context: context);
        final id = idList[index];
        final note = notes.get(id);

        Note? front;

        if (index > 0) {
          front = notes.get(idList[index - 1]);
        }

        // if(index == 0) {
        //   borderRadius = const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomRight:  Radius.circular(0), bottomLeft: Radius.circular(0));
        // }
        // else if(index == length - 1) {
        //   borderRadius = const BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0), bottomRight:  Radius.circular(15), bottomLeft: Radius.circular(15));
        //   borderSide = const BorderSide(
        //     color: Colors.transparent,
        //     width: 1,
        //   );
        // }
        // if(length == 1) {
        //   borderRadius = BorderRadius.circular(15);
        //   borderSide = const BorderSide(
        //     color: Colors.transparent,
        //     width: 1,
        //   );
        // }

        return NoteLinearItem(
            note: note,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(front == null ? 15 : 0),
                topRight: Radius.circular(front == null ? 15 : 0),
                bottomRight: Radius.circular(index == idList.length -1 ? 15 : 0),
                bottomLeft: Radius.circular(index == idList.length -1 ? 15 : 0)),
            showDivider: index != idList.length -1,
    );
  }

  );
}}

void onNotePressed(Note note) {

}

void onFolderPressed(Folder folder) {
  // if (folder.location != "!Trashes" && appStorage.selectedNotes == null) {
  //   if (App.isWideScreen(context)) {
  //     appState.notifySomethingChanged(() {
  //       appState.history.add(folder);
  //     });
  //   } else {
  //     Navigator.push(context, CupertinoPageRoute(builder: (context) {
  //       return MainView(
  //         location: folder.filename,
  //         title: folder.title,
  //       );
  //     }));
  //   }
  // }
}
