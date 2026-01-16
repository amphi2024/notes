import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/note_thumbnail.dart';
import 'package:notes/utils/date_utils.dart';
import 'package:notes/models/note.dart';
import 'package:notes/utils/note_item_press_callback.dart';
import '../../../providers/selected_notes_provider.dart';


class NoteGridItem extends ConsumerWidget {
  final Note note;

  const NoteGridItem({super.key, required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotes = ref.watch(selectedNotesProvider);
    final selectingNotes = selectedNotes != null;

    return Material(
      color: note.backgroundColorByTheme(context),
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onLongPress: () {
          ref.read(selectedNotesProvider.notifier).startSelection();
        },
        onTap: () {
          onNotePressed(note, context, ref);
        },
        highlightColor: Color.fromARGB(25, 125, 125, 125),
        splashColor: Color.fromARGB(25, 125, 125, 125),
        borderRadius: BorderRadius.circular(15),
        child: GestureDetector(
          onLongPress: () {
            ref.read(selectedNotesProvider.notifier).startSelection();
          },
          onTap: () {
            onNotePressed(note, context, ref);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: note.thumbnailData != null,
                  child: NoteThumbnail(
                      thumbnailData: note.thumbnailData!,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)))),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 13.0),
                child: Text(note.title, style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold,
                    color: note.textColorByTheme(context)),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 13.0),
                child: Text(
                  note.longSubtitle, maxLines: 10, style: TextStyle(
                    color: note.textColorByTheme(context)
                ),),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutQuint,
                    opacity: selectingNotes ? 1.0 : 0,
                    child: IgnorePointer(
                      ignoring: !selectingNotes,
                      child: Checkbox(
                          value: selectedNotes?.contains(
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
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                    child: Text(
                      note.modified.toLocalizedShortString(context),
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Theme
                          .of(context)
                          .disabledColor, fontSize: 10),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
