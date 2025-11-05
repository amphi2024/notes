
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes/icons/icons.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:notes/providers/selected_notes_provider.dart';


class ChooseFolderDialog extends ConsumerStatefulWidget {

  final String folderId;
  const ChooseFolderDialog({super.key, required this.folderId});

  @override
  ConsumerState<ChooseFolderDialog> createState() => _ChooseFolderDialogState();
}

class _ChooseFolderDialogState extends ConsumerState<ChooseFolderDialog> {

  List<String> history = [];

  @override
  Widget build(BuildContext context) {
    final selectedNotes = ref.watch(selectedNotesProvider) ?? [];
    final idList =
        ref.watch(notesProvider).idListByFolderIdFolderOnly(history.firstOrNull ?? "").where((id) => !selectedNotes.contains(id)).toList();
    if (history.isNotEmpty) {
      idList.insert(0, "!POP");
    }
    final notes = ref.watch(notesProvider).notes;

    return Dialog(
      child: SizedBox(
        width: 250,
        height: 500,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () {
                  Navigator.pop(context);
                }, icon: const Icon(Icons.cancel_outlined, size: 20)),
                IconButton(onPressed: () {
                  final parentId = history.firstOrNull ?? "";
                  for(var id in selectedNotes) {
                    ref.read(notesProvider).notes.get(id).parentId = parentId;
                    ref.read(notesProvider).notes.get(id).save();
                  }
                  ref.read(notesProvider.notifier).moveNotes(selectedNotes, widget.folderId, parentId);
                  Navigator.pop(context);
                }, icon: const Icon(Icons.check_circle_outline, size: 20))
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                    itemCount: idList.length,
                    itemBuilder: (context, index) {
                      final folder = notes.get(idList[index]);

                      final roundedTop = index == 0;

                      final roundBottom = index == idList.length - 1;

                      final borderRadius = BorderRadius.only(
                          topLeft: Radius.circular(roundedTop ? 15 : 0),
                          topRight: Radius.circular(roundedTop ? 15 : 0),
                          bottomRight: Radius.circular(roundBottom ? 15 : 0),
                          bottomLeft: Radius.circular(roundBottom ? 15 : 0));

                      return Material(
                        color: Theme.of(context).cardColor,
                        borderRadius: borderRadius,
                        child: InkWell(
                          highlightColor: Color.fromARGB(25, 125, 125, 125),
                          splashColor: Color.fromARGB(25, 125, 125, 125),
                          borderRadius: borderRadius,
                          onTap: () {
                              if(folder.id == "!POP") {
                                setState(() {
                                  history.removeLast();
                                });
                              }
                              else {
                                setState(() {
                                  history.add(folder.id);
                                });
                              }
                          },
                          child: SizedBox(
                            height: 60,
                            child: Stack(
                              children: [
                                if (!roundBottom) ...[
                                  Positioned(
                                      left: 10,
                                      right: 0,
                                      bottom: 0,
                                      child: Divider(
                                        color: Theme.of(context).dividerColor,
                                        height: 1,
                                        thickness: 1,
                                      )),
                                ],
                                Positioned.fill(
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
                                              folder.id == "!POP" ? ".." : folder.title,
                                              style: TextStyle(
                                                  color: Theme.of(context).colorScheme.onSurface, fontSize: 15, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ))
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
