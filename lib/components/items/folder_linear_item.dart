import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/dialogs/edit_folder_dialog.dart';
import 'package:notes/extensions/date_extension.dart';

import '../../icons/icons.dart';
import '../../models/note.dart';
import '../../providers/notes_provider.dart';
import '../../providers/selected_notes_provider.dart';
import '../../utils/note_item_press_callback.dart';

class FolderLinearItem extends ConsumerWidget {
  final Note note;
  final BorderRadius borderRadius;
  final bool showDivider;
  const FolderLinearItem({super.key, required this.note, required this.borderRadius, required this.showDivider});

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
          onFolderPressed(note, context, ref);
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
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Icon(
                          AppIcons.folder,
                          size: 25,
                        ),
                      ),
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
                                Expanded(child: Text(ref.watch(notesProvider).idListByFolderId(note.id).length.toString())),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

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
                    child: IgnorePointer(
                      ignoring: !selectingNotes,
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          size: 20,
                        ),
                        onPressed: () {
                          showDialog(context: context, builder: (context) {
                            return EditFolderDialog(folder: note, ref: ref);
                          });
                        },
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
