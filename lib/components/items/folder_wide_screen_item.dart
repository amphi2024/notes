import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/icons/icons.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/providers.dart';

class FolderWideScreenItem extends ConsumerWidget {

  final Note folder;
  final void Function() onPressed;
  final void Function() onIconPressed;
  final int itemCount;
  final bool expanded;
  final bool iconVisible;
  final double indent;
  const FolderWideScreenItem(
      {super.key, required this.folder, required this.onPressed, required this.onIconPressed, required this.expanded, required this.itemCount, required this.iconVisible, required this.indent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedFolderProvider) == folder.id;
    final textColor = selected ? Colors.white : null;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: selected ? BoxDecoration(shape: BoxShape.rectangle, color: Theme
            .of(context)
            .highlightColor
            .withAlpha(200), borderRadius: BorderRadius.circular(8)) : BoxDecoration(
            color: Theme
                .of(context)
                .drawerTheme
                .backgroundColor
        ),
        child: Row(
          children: [
            Opacity(
              opacity: iconVisible ? 1 : 0,
              child: Padding(
                padding: EdgeInsets.only(left: 5.0 + indent),
                child: AnimatedRotation(
                    turns: expanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: GestureDetector(
                        onTap: onIconPressed,
                        child: Icon(Icons.keyboard_arrow_right_rounded, color: textColor))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5, bottom: 5, top: 5),
              child: Icon(
                  folder.id == "!TRASH" ? AppIcons.trash : Icons.folder_outlined,
                  color: selected ? Colors.white : Theme
                      .of(context)
                      .highlightColor),
            ),
            Expanded(child: Text(folder.title, style: TextStyle(color: textColor), overflow: TextOverflow.ellipsis)),
            Visibility(
              visible: itemCount > 0,
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(itemCount.toString(), style: TextStyle(
                    color: textColor
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
