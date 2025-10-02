import 'package:amphi/utils/file_name_utils.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/image_from_storage_rounded.dart';
import 'package:notes/components/main/list_view/linear_item_border.dart';
import 'package:notes/components/main/list_view/list_view_item.dart';
import 'package:notes/extensions/date_extension.dart';

import 'package:notes/models/note.dart';

import '../../../models/app_storage.dart';

class NoteLinearItem extends ListViewItem {
  final Note note;
  final LinearItemBorder linearItemBorder;

  const NoteLinearItem({super.key, required super.onPressed, required super.onLongPress, required this.note, required this.linearItemBorder});

  @override
  State<NoteLinearItem> createState() => _NoteLinearItemState();
}

class _NoteLinearItemState extends State<NoteLinearItem> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    if (appStorage.selectedNotes == null) {
      selected = false;
    }
    return GestureDetector(
      onLongPress: widget.onLongPress,
      onTap: widget.onPressed,
      child: Container(
          margin: const EdgeInsets.only(left: 7.5, right: 7.5, top: 0, bottom: 0),
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
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutQuint,
                top: 0,
                right: 8,
                bottom: 0,
                left: appStorage.selectedNotes != null ? 50 : 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            widget.note.title,
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                            maxLines: 1,
                          ),
                          Text(
                            widget.note.subtitle.isEmpty
                                ? widget.note.modified.toLocalizedShortString(context)
                                : "${widget.note.modified.toLocalizedShortString(context)}   ${widget.note.subtitle}",
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, overflow: TextOverflow.ellipsis),
                            maxLines: 1,
                          )
                        ],
                      ),
                    ),
                    // Visibility(
                    //     visible: widget.note.thumbnailImageFilename != null,
                    //     child: SizedBox(
                    //   width: 42,
                    //   height: 42,
                    //   child: widget.note.thumbnailImageFilename != null ?  ImageFromStorageRounded(
                    //       noteName: FilenameUtils.nameOnly(widget.note.filename),
                    //       filename: widget.note.thumbnailImageFilename ?? "",
                    //       borderRadius: BorderRadius.circular(10)): Placeholder(),
                    // ))
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
//   "${widget.note.modified.toLocalizedShortString(context)}   $secondLine",
