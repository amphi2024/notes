import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/main/edit_folder_dialog.dart';
import 'package:notes/extensions/date_extension.dart';

import 'package:notes/models/note.dart';
import 'package:notes/utils/note_item_press_callback.dart';

import '../../providers/notes_provider.dart';
import '../../providers/selected_notes_provider.dart';

class FolderGridItem extends ConsumerWidget {
  final Note folder;

  const FolderGridItem({super.key, required this.folder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotes = ref.watch(selectedNotesProvider);
    final selectingNotes = selectedNotes != null;

    return GestureDetector(
      onLongPress: () {
        ref.read(selectedNotesProvider.notifier).startSelection();
      },
      onTap: () {
        onFolderPressed(folder, context, ref);
      },
      child: Container(
        margin: const EdgeInsets.all(7.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 70,
              height: 15,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Theme.of(context).colorScheme.surface),
              ),
            ),
            Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Theme.of(context).colorScheme.surface),
                child: Stack(
                  children: [
                    Positioned(
                      top: 5.0,
                      left: 10.0,
                      child: Text(folder.title,
                          style: const TextStyle(fontSize: 18)),
                    ),
                    Positioned(
                      bottom: 0.0,
                      right: 10,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 5.0, bottom: 10.0),
                        child: Text(
                          folder.modified.toLocalizedShortString(context),
                          style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).disabledColor),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 25,
                        right: 10.0,
                        child: Text(
                          ref.watch(notesProvider).idListByFolderId(folder.id).length.toString(),
                          style: TextStyle(fontSize: 10, color: Theme.of(context).disabledColor),
                        )),
                    Positioned(
                        left: 10,
                        bottom: 0,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeOutQuint,
                          opacity: selectingNotes ? 1.0 : 0,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: IgnorePointer(
                                  ignoring: !selectingNotes,
                                  child: Checkbox(
                                      value:
                                          selectedNotes?.contains(folder.id) ==
                                              true,
                                      onChanged: (bool? value) {
                                        if (value == true) {
                                          ref
                                              .read(selectedNotesProvider
                                                  .notifier)
                                              .addId(folder.id);
                                        } else {
                                          ref
                                              .read(selectedNotesProvider
                                                  .notifier)
                                              .removeId(folder.id);
                                        }
                                      }),
                                ),
                              ),
                              IconButton(
                                  icon: Icon(Icons.edit, size: 20),
                                  onPressed: () {
                                    showDialog(context: context, builder: (context) {
                                      return EditFolderDialog(folder: folder, ref: ref);
                                    });
                                  })
                            ],
                          ),
                        ))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
