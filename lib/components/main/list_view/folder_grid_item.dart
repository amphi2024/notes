import 'package:flutter/material.dart';
import 'package:notes/components/main/list_view/list_view_item.dart';
import 'package:notes/extensions/date_extension.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/folder.dart';

class FolderGridItem extends ListViewItem {
  final Folder folder;
  final void Function() toUpdateFolder;
  const FolderGridItem({super.key, required super.onPressed, required super.onLongPress, required this.folder, required this.toUpdateFolder});

  @override
  State<FolderGridItem> createState() => _FolderItemGridState();
}

class _FolderItemGridState extends State<FolderGridItem> {
  bool selected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (appStorage.selectedNotes == null) {
          widget.onLongPress();
        }
      },
      onTap: () {
        if (appStorage.selectedNotes == null) {
          widget.onPressed();
        }
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
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    color: Theme.of(context).colorScheme.surface),
              ),
            ),
            Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.only(bottomLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                    color: Theme.of(context).colorScheme.surface),
                child: Stack(
                  children: [
                    Positioned(
                      top: 5.0,
                      left: 10.0,
                      child: Text(widget.folder.title, style: const TextStyle(fontSize: 18)),
                    ),
                    Positioned(
                      bottom: 0.0,
                      right: 10,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 10.0),
                        child: Text(
                          widget.folder.modified.toLocalizedShortString(context),
                          style: TextStyle(fontSize: 10, color: Theme.of(context).disabledColor),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 25,
                        right: 10.0,
                        child: Text(
                          "${AppStorage.getNoteList(widget.folder.filename).length}",
                          style: TextStyle(fontSize: 10, color: Theme.of(context).disabledColor),
                        )),
                    Positioned(
                        left: 10,
                        bottom: 0,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeOutQuint,
                          opacity: appStorage.selectedNotes != null ? 1.0 : 0,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: Checkbox(
                                    value: selected,
                                    onChanged: (bool? value) {
                                      if (appStorage.selectedNotes != null) {
                                        setState(() {
                                          selected = value!;
                                        });
                                        if (selected) {
                                          appStorage.selectedNotes!.add(widget.folder);
                                        } else {
                                          appStorage.selectedNotes!.remove(widget.folder);
                                        }
                                      }
                                    }),
                              ),
                              IconButton(
                                  icon: Icon(Icons.build_circle_outlined, size: 20),
                                  onPressed: () {
                                    widget.toUpdateFolder();
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
