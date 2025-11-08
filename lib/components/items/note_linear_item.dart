import 'package:amphi/models/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/note_image_rounded.dart';
import 'package:notes/utils/date_utils.dart';

import 'package:notes/models/note.dart';
import 'package:notes/providers/editing_note_provider.dart';
import 'package:notes/providers/selected_notes_provider.dart';

import '../../utils/note_item_press_callback.dart';

class NoteLinearItem extends ConsumerWidget {
  final Note note;
  final BorderRadius borderRadius;
  final bool showDivider;
  const NoteLinearItem({super.key, required this.note, required this.borderRadius, required this.showDivider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotes = ref.watch(selectedNotesProvider);
    final selectingNotes = selectedNotes != null && !App.isDesktop();
    final focused = selectedNotes != null ? selectedNotes.contains(note.id) : ref.watch(editingNoteProvider).note.id == note.id;
    final themeData = Theme.of(context);

    final widget = Material(
      color: App.isDesktop() && focused ? themeData.highlightColor.withAlpha(100) : themeData
          .cardColor,
      borderRadius: borderRadius,
      child: InkWell(
        mouseCursor: SystemMouseCursors.basic,
        highlightColor: Color.fromARGB(25, 125, 125, 125),
        splashColor: Color.fromARGB(25, 125, 125, 125),
        borderRadius: borderRadius,
        onTap: () {
          onNotePressed(note, context, ref);
        },
        onLongPress: () {
          ref.read(selectedNotesProvider.notifier).startSelection();
        },
        child: SizedBox(
          height: App.isDesktop() ? 70 : 60,
          child: Stack(
            children: [
              if(showDivider || (App.isDesktop()) && focused) ... [
                AnimatedPositioned(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutQuint,
                    left: selectingNotes ? 50 : 10,
                    right: 0,
                    bottom: 0,
                    child: Padding(
                      padding: App.isDesktop() ? const EdgeInsets.only(right: 5.0 , bottom: 5) : EdgeInsets.zero,
                      child: Divider(
                        color: themeData.dividerColor,
                        height: 1,
                        thickness: 1,
                      ),
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
                                Expanded(child: Text(note.subtitle)),
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
                          child: note.thumbnailImageFilename != null ?  NoteImageRounded(
                              noteId: note.id,
                              filename: note.thumbnailImageFilename ?? "",
                              borderRadius: BorderRadius.circular(10)): Placeholder(),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

    if(App.isDesktop()) {
      return Draggable<List<String>>(
        data: selectedNotes ?? [note.id],
        dragAnchorStrategy: pointerDragAnchorStrategy,
        feedback: Icon(Icons.note),
        child: widget,
      );
    }

    return widget;
  }
}