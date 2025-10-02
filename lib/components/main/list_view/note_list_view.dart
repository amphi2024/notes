import 'package:amphi/models/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/components/main/list_view/folder_grid_item.dart';
import 'package:notes/components/main/list_view/folder_linear_item.dart';
import 'package:notes/components/main/list_view/linear_item_border.dart';
import 'package:notes/components/main/list_view/note_grid_item.dart';
import 'package:notes/components/main/list_view/note_linear_item.dart';
import 'package:notes/models/app_settings.dart';

import 'package:notes/models/folder.dart';
import 'package:notes/models/note.dart';

class NoteListView extends StatefulWidget {
  final List<dynamic> noteList;
  final void Function(Note) onNotePressed;
  final VoidCallback onLongPress;
  final void Function(Folder) toUpdateFolder;
  const NoteListView({super.key, required this.noteList, required this.onNotePressed, required this.onLongPress, required this.toUpdateFolder});

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> with AutomaticKeepAliveClientMixin<NoteListView> {
  // ScrollController scrollController = ScrollController(initialScrollOffset: appState.noteListScrollPosition);
  ScrollController scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

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
    if (appSettings.viewMode == "linear") {
      return ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemCount: widget.noteList.length,
          itemBuilder: (context, index) {
            LinearItemBorder border = LinearItemBorder(index: index, length: widget.noteList.length, context: context);
            if (widget.noteList[index] is Folder) {
              return FolderLinearItem(
                linearItemBorder: border,
                onPressed: () => onFolderPressed(widget.noteList[index]),
                onLongPress: widget.onLongPress,
                folder: widget.noteList[index],
                toUpdateFolder: () {
                  // if (appStorage.selectedNotes != null) {
                  //   widget.toUpdateFolder(widget.noteList[index]);
                  // }
                },
              );
            } else {
              return NoteLinearItem(
                  linearItemBorder: border,
                  onPressed: () => widget.onNotePressed(widget.noteList[index]),
                  onLongPress: widget.onLongPress,
                  note: widget.noteList[index]);
            }
          });
    } else {
      return LayoutBuilder(builder: (context, constraints) {
        double width = constraints.maxWidth;
        int axisCount = (width / 150).toInt();
        return MasonryGridView.builder(
          controller: scrollController,
          itemCount: widget.noteList.length,
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: axisCount),
          itemBuilder: (context, index) {
            if (widget.noteList[index] is Folder) {
              return FolderGridItem(
                onPressed: () => onFolderPressed(widget.noteList[index]),
                onLongPress: widget.onLongPress,
                folder: widget.noteList[index] as Folder,
                toUpdateFolder: () {
                  widget.toUpdateFolder(widget.noteList[index]);
                },
              );
            } else {
              return NoteGridItem(
                  onPressed: () => widget.onNotePressed(widget.noteList[index]),
                  onLongPress: widget.onLongPress,
                  note: widget.noteList[index] as Note);
            }
          },
        );
      });
    }
  }
}
