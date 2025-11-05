import 'package:amphi/models/app.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/dialogs/folder_picker_dialog.dart';
import 'package:notes/dialogs/edit_folder_dialog.dart';
import 'package:notes/icons/icons.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/providers.dart';
import 'package:notes/providers/selected_notes_provider.dart';
import 'package:notes/utils/generate_id.dart';

import '../../providers/notes_provider.dart';

class FolderWideScreenItem extends ConsumerStatefulWidget {
  final void Function() onIconPressed;
  final Note folder;
  final bool iconVisible;
  final void Function() onPressed;
  final bool expanded;
  final double indent;
  final int itemCount;

  const FolderWideScreenItem(
      {super.key,
      required this.folder,
      required this.onPressed,
      required this.onIconPressed,
      required this.expanded,
      required this.itemCount,
      required this.iconVisible,
      required this.indent});

  @override
  FolderWideScreenItemState createState() => FolderWideScreenItemState();
}

class FolderWideScreenItemState extends ConsumerState<FolderWideScreenItem> {
  bool editButtonShowing = false;

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedFolderProvider) == widget.folder.id;
    final textColor = selected ? Colors.white : null;

    final item = GestureDetector(
      onLongPress: () {
        if(!App.isDesktop()) {
          setState(() {
            editButtonShowing = !editButtonShowing;
          });
        }
      },
      onTap: widget.onPressed,
      child: Container(
        decoration: selected
            ? BoxDecoration(
            shape: BoxShape.rectangle, color: Theme.of(context).highlightColor.withAlpha(200), borderRadius: BorderRadius.circular(8))
            : BoxDecoration(color: Theme.of(context).drawerTheme.backgroundColor),
        child: Row(
          children: [
            Opacity(
              opacity: widget.iconVisible ? 1 : 0,
              child: Padding(
                padding: EdgeInsets.only(left: 5.0 + widget.indent),
                child: AnimatedRotation(
                    turns: widget.expanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: GestureDetector(onTap: widget.onIconPressed, child: Icon(Icons.keyboard_arrow_right_rounded, color: textColor))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5, bottom: 5, top: 5),
              child: Icon(widget.folder.id == "!TRASH" ? AppIcons.trash : Icons.folder_outlined,
                  color: selected ? Colors.white : Theme.of(context).highlightColor),
            ),
            Expanded(child: Text(widget.folder.title, style: TextStyle(color: textColor), overflow: TextOverflow.ellipsis)),
            Visibility(
              visible: widget.folder.id != "!TRASH" && widget.folder.id.isNotEmpty && editButtonShowing,
              child: PopupMenuButton(
                  icon: Icon(Icons.more_horiz, size: 15),
                  itemBuilder: (context) => _menuItems(folder: widget.folder, ref: ref, context: context)),
            ),
            Visibility(
              visible: widget.itemCount > 0,
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(widget.itemCount.toString(), style: TextStyle(color: textColor)),
              ),
            )
          ],
        ),
      ),
    );

    if(App.isDesktop()) {
      return DragTarget<List<String>>(onWillAcceptWithDetails: (details) {
        return details.data.firstOrNull != widget.folder.id && details.data.firstOrNull != widget.folder.parentId;
      }, onAcceptWithDetails: (details) {
        final selectedNotes = details.data;
        String? folderId = null;
        final deleted = widget.folder.id != "!TRASH" ? null : DateTime.now();
        for (var id in selectedNotes) {
          final item = ref.watch(notesProvider).notes.get(id);
          folderId = item.parentId;
          item.parentId = widget.folder.id != "!TRASH" ? widget.folder.id : "";
          item.deleted = deleted;
          item.save();
        }
        ref.read(notesProvider.notifier).moveNotes(details.data, folderId ?? "", widget.folder.id);
      }, builder: (context, candidateData, rejectedData) {
        return Draggable<List<String>>(
            dragAnchorStrategy: pointerDragAnchorStrategy,
            feedback: Icon(Icons.folder_outlined),
            data: [widget.folder.id],
            child: MouseRegion(
              onHover: (d) {
                setState(() {
                  editButtonShowing = true;
                });
              },
              onExit: (event) {
                setState(() {
                  editButtonShowing = false;
                });
              },
              child: item,
            ));
      });
    }

    return item;
  }
}

const _height = 30.0;

List<PopupMenuItem> _menuItems({required Note folder, required WidgetRef ref, required BuildContext context}) {
  if(folder.deleted == null) {
    return [
      PopupMenuItem(height: _height, child: Text("New Folder"), onTap: () async {
        final id = await generatedNoteId();
        final newFolder = Note(id: id);
        showDialog(context: context, builder: (context) {
          return EditFolderDialog(folder: newFolder, ref: ref);
        });
      }),
      PopupMenuItem(height: _height, child: Text("Rename Folder"), onTap: () {
        showDialog(context: context, builder: (context) {
          return EditFolderDialog(folder: folder, ref: ref);
        });
      }),
      PopupMenuItem(height: _height, child: Text("Move"), onTap: () async {
        ref.read(selectedNotesProvider.notifier).startSelection();
        ref.read(selectedNotesProvider.notifier).addId(folder.id);
        await showDialog(context: context, builder: (context) {
          return FolderPickerDialog(folderId: folder.parentId);
        });
        ref.read(selectedNotesProvider.notifier).endSelection();
      }),
      PopupMenuItem(height: _height, child: Text("Move to trash"), onTap: () {
        folder.deleted = DateTime.now();
        folder.save();
        ref.read(notesProvider.notifier).moveNotes([folder.id], folder.parentId, "!TRASH");
      }),
    ];
  }

  return [
    PopupMenuItem(height: _height, child: Text("Restore Folder"), onTap: () {
      folder.deleted = null;
      folder.parentId = "";
      folder.save();
      ref.read(notesProvider.notifier).moveNotes([folder.id], "!TRASH", folder.parentId);
    }),
    PopupMenuItem(height: _height, child: Text("Delete Folder"), onTap: () {
      showDialog(context: context, builder: (context) {
        return ConfirmationDialog(title: "", onConfirmed: () {
          folder.delete(ref: ref);
          ref.read(notesProvider.notifier).deleteNotes([folder.id]);
        });
      });
    })
  ];
}