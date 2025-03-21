import 'package:flutter/material.dart';
import 'package:notes/components/main/list_view/linear_item_border.dart';
import 'package:notes/components/main/list_view/list_view_item.dart';
import 'package:notes/extensions/date_extension.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/folder.dart';
import 'package:notes/models/icons.dart';

class FolderLinearItem extends ListViewItem {
  final Folder folder;
  final LinearItemBorder linearItemBorder;
  final void Function() toUpdateFolder;

  const FolderLinearItem(
      {super.key,
      required this.folder,
      required super.onPressed,
      required super.onLongPress,
      required this.linearItemBorder,
      required this.toUpdateFolder});

  @override
  State<FolderLinearItem> createState() => _FolderLinearItemState();
}

class _FolderLinearItemState extends State<FolderLinearItem> {
  bool selected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (appStorage.selectedNotes == null) {
      setState(() {
        selected = false;
      });
    }

    return GestureDetector(
      onLongPress: widget.onLongPress,
      onTap: widget.onPressed,
      child: Container(
        margin: const EdgeInsets.only(left: 7.5, right: 7.5),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: widget.linearItemBorder.borderSide,
            ),
            borderRadius: widget.linearItemBorder.borderRadius),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutQuint,
              top: 0.0,
              bottom: 0.0,
              left: appStorage.selectedNotes != null ? 10.0 : 0.0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutQuint,
                opacity: appStorage.selectedNotes != null ? 1.0 : 0,
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Checkbox(
                      value: selected,
                      onChanged: (bool? value) {
                        setState(() {
                          selected = value!;
                        });
                        if (selected) {
                          appStorage.selectedNotes!.add(widget.folder);
                        } else {
                          appStorage.selectedNotes!.remove(widget.folder);
                        }
                      }),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutQuint,
              left: appStorage.selectedNotes != null ? 40 : 0,
              top: 0,
              bottom: 0,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Icon(
                      AppIcons.folder,
                      size: 25,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          widget.folder.title,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "${widget.folder.modified.toLocalizedShortString(context)}   ${AppStorage.getNoteList(widget.folder.filename).length}",
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            ),
                          ],
                        )
                      ],
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
              right: appStorage.selectedNotes != null && widget.folder.location != "!Trashes" ? 10.0 : 0.0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutQuint,
                opacity: appStorage.selectedNotes != null && widget.folder.location != "!Trashes" ? 1.0 : 0,
                child: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                  ),
                  onPressed: () {
                    widget.toUpdateFolder();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
