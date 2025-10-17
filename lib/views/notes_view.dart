import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:notes/components/items/folder_grid_item.dart';
import '../components/items/folder_linear_item.dart';
import '../components/items/note_grid_item.dart';
import '../components/items/note_linear_item.dart';
import '../models/app_cache_data.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import '../utils/data_sync.dart';

class NotesView extends ConsumerStatefulWidget {
  final Note folder;
  final List<String> idList;

  const NotesView({super.key, required this.idList, required this.folder});

  @override
  ConsumerState<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends ConsumerState<NotesView> {

  Future<void> refresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    refreshDataWithServer(ref);
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref
        .watch(notesProvider)
        .notes;
    final idList = widget.idList;
    if (appCacheData.viewMode(widget.folder.id) == "linear") {
      return RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
            itemCount: idList.length,
            itemBuilder: (context, index) {
              final id = idList[index];
              final note = notes.get(id);

              final roundedTop = index == 0 || notes.get(idList[index - 1]).modified.difference(note.modified).inDays > 30 || note.modified.difference(notes.get(idList[index - 1]).modified).inDays > 30;

              final roundBottom = index == idList.length - 1 || note.modified.difference(notes.get(idList[index + 1]).modified).inDays > 30 || notes.get(idList[index + 1]).modified.difference(note.modified).inDays > 30;

              final itemWidget = note.isFolder ? FolderLinearItem(
                note: note,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(roundedTop ? 15 : 0),
                    topRight: Radius.circular(roundedTop ? 15 : 0),
                    bottomRight: Radius.circular(roundBottom ? 15 : 0),
                    bottomLeft: Radius.circular(roundBottom ? 15 : 0)),
                showDivider: !roundBottom,
              ): NoteLinearItem(
                note: note,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(roundedTop ? 15 : 0),
                    topRight: Radius.circular(roundedTop ? 15 : 0),
                    bottomRight: Radius.circular(roundBottom ? 15 : 0),
                    bottomLeft: Radius.circular(roundBottom ? 15 : 0)),
                showDivider: !roundBottom,
              );

              if(roundedTop && appCacheData.shouldGroupNotes(widget.folder.id)) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                       DateTime.now().difference(note.modified).inDays < 8 ? "This Week" : DateFormat.MMMM().format(note.modified),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ),
                      ),
                    ),
                    itemWidget
                  ],
                );
              }

              return itemWidget;
            }

        ),
      );
    } else {
      return LayoutBuilder(builder: (context, constraints) {
        double width = constraints.maxWidth;
        int axisCount = (width / 150).toInt();
        return MasonryGridView.builder(
          itemCount: widget.idList.length,
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: axisCount),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          itemBuilder: (context, index) {
            final id = idList[index];
            final note = notes.get(id);
            if(note.isFolder) {
              return FolderGridItem(folder: note);
            }
            return NoteGridItem(note: note);
          },
        );
      });
    }
}}