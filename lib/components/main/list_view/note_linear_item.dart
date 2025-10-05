import 'package:amphi/utils/file_name_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/image_from_storage_rounded.dart';
import 'package:notes/components/main/list_view/linear_item_border.dart';
import 'package:notes/components/main/list_view/list_view_item.dart';
import 'package:notes/extensions/date_extension.dart';

import 'package:notes/models/note.dart';
import 'package:notes/pages/main_page.dart';
import 'package:notes/pages/note_page.dart';
import 'package:notes/providers/editing_note_provider.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:notes/providers/selected_notes_provider.dart';

import '../../../models/app_storage.dart';
import '../../../icons/icons.dart';

class NoteLinearItem extends ConsumerWidget {
  final Note note;
  final BorderRadius borderRadius;
  final bool showDivider;
  const NoteLinearItem({super.key, required this.note, required this.borderRadius, required this.showDivider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectingNotes = ref.watch(selectedNotesProvider) != null;

    return Material(
      color: Theme
          .of(context)
          .cardColor,
      borderRadius: borderRadius,
      child: InkWell(
        highlightColor: Color.fromARGB(25, 125, 125, 125),
        splashColor: Color.fromARGB(25, 125, 125, 125),
        borderRadius: borderRadius,
        onTap: () {
          if(note.isFolder) {
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return MainPage(folder: note);
            }));
          }
          else {
            ref.read(editingNoteProvider.notifier).setNote(note);
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return NotePage();
            }));
          }
        },
        onLongPress: () {
          ref.read(selectedNotesProvider.notifier).startSelection();
        },
        child: SizedBox(
          height: 60,
          child: Stack(
            children: [
              if(showDivider) ... [
                AnimatedPositioned(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutQuint,
                    left: selectingNotes ? 50 : 10,
                    right: 0,
                    bottom: 0,
                    child: Divider(
                      color: Theme
                          .of(context)
                          .dividerColor,
                      height: 1,
                      thickness: 1,
                    )
                ),
              ],
              AnimatedPositioned(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutQuint,
                top: 0.0,
                bottom: 0.0,
                left: selectingNotes ? 10.0 : 0.0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutQuint,
                  opacity: selectingNotes ? 1.0 : 0,
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: IgnorePointer(
                      ignoring: !selectingNotes,
                      child: Checkbox(
                          value: ref.watch(selectedNotesProvider)?.contains(
                              note.id) == true,
                          onChanged: (bool? value) {
                            if (value == true) {
                              ref.read(selectedNotesProvider.notifier).addId(note.id);
                            }
                            else {
                              ref.read(selectedNotesProvider.notifier).removeId(note.id);
                            }
                          }),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutQuint,
                left: selectingNotes ? 40 : 0,
                top: 0,
                bottom: 0,
                right: 10,
                child: Row(
                  children: [
                    if(note.isFolder) ...[
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Icon(
                          AppIcons.folder,
                          size: 25,
                        ),
                      ),
                    ],
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              note.title,
                              style: TextStyle(color: Theme
                                  .of(context)
                                  .colorScheme
                                  .onSurface,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(note.modified.toLocalizedShortString(context)),
                                ),
                                Expanded(child: Text(note.isFolder ? ref.watch(notesProvider).idListByFolderId(note.id).length.toString() : note.subtitle)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                        visible: note.thumbnailImageFilename != null,
                        child: SizedBox(
                      width: 42,
                      height: 42,
                      child: note.thumbnailImageFilename != null ?  ImageFromStorageRounded(
                          noteId: note.id,
                          filename: note.thumbnailImageFilename ?? "",
                          borderRadius: BorderRadius.circular(10)): Placeholder(),
                    ))
                  ],
                ),
              ),

              if(note.isFolder)...[
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutQuint,
                  top: 0.0,
                  bottom: 0.0,
                  right: selectingNotes &&
                      note.deleted == null ? 10.0 : 0.0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutQuint,
                    opacity: selectingNotes &&
                        note.deleted == null ? 1.0 : 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                      ),
                      onPressed: () {

                      },
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
