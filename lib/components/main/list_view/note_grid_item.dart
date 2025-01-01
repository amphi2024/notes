import 'package:amphi/utils/file_name_utils.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/image_from_storage_rounded.dart';
import 'package:notes/components/main/list_view/list_view_item.dart';
import 'package:notes/extensions/date_extension.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/note.dart';

class NoteGridItem extends ListViewItem {
  final Note note;

  const NoteGridItem({super.key, required this.note, required super.onPressed, required super.onLongPress});

  @override
  State<NoteGridItem> createState() => _NoteGridItemState();
}

class _NoteGridItemState extends State<NoteGridItem> {

  bool selected = false;

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
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Theme.of(context).cardColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: widget.note.thumbnailImageFilename != null,
                child: ImageFromStorageRounded(
                    noteName: FilenameUtils.nameOnly(widget.note.filename),
                    filename: widget.note.thumbnailImageFilename ?? "",
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)))),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 13.0),
              child: Text(widget.note.title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 13.0),
              child: Text(widget.note.longSubtitle, maxLines: 5,),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 13.0),
            //   child: ParsedContents(
            //     note: widget.note,
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutQuint,
                  opacity: appStorage.selectedNotes != null ? 1.0 : 0,
                  child: Checkbox(
                      value: selected,
                      onChanged: (bool? value) {
                        if (appStorage.selectedNotes != null) {
                          setState(() {
                            selected = value!;
                          });
                          if (selected) {
                            appStorage.selectedNotes!.add(widget.note);
                          } else {
                            appStorage.selectedNotes!.remove(widget.note);
                          }
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                  child: Text(
                    widget.note.modified.toLocalizedShortString(context),
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Theme.of(context).disabledColor, fontSize: 10),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
