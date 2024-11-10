import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/embed_block/sub_note/edit_sub_note_dialog.dart';
import 'package:notes/components/note_editor/embed_block/view_pager/view_pager_data.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/components/note_editor/note_editor.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/note.dart';

class ViewPagerBlockWidget extends StatefulWidget {
  final String viewPagerKey;
  final bool readOnly;

  const ViewPagerBlockWidget({super.key, required this.viewPagerKey, required this.readOnly});

  @override
  State<ViewPagerBlockWidget> createState() => _ViewPagerBlockWidgetState();
}

class _ViewPagerBlockWidgetState extends State<ViewPagerBlockWidget> {
  @override
  Widget build(BuildContext context) {
    ViewPagerData viewPagerData = appState.noteEditingController.note.getViewPager(widget.viewPagerKey);
    List<Widget> children = [];
double height = viewPagerData.style["height"] ?? 250;
    for(NoteEditingController noteEditingController in viewPagerData.pages) {
      noteEditingController.readOnly = true;

      if(!widget.readOnly) {
        children.add(
            MouseRegion(
              cursor: SystemMouseCursors.basic,
              child: GestureDetector(
                onTap: () {
                  showDialog(context: context, builder: (context) => EditSubNoteDialog(noteEditingController: noteEditingController));
                },
                  child: SizedBox(
                      height: height,
                      child: NoteEditor(noteEditingController: noteEditingController))),
            )
        );
      }
      else {
        children.add(
            NoteEditor(noteEditingController: noteEditingController)
        );
      }

    }

    children.add(Center(
      child: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              appState.noteEditingController.note
                  .getViewPager(widget.viewPagerKey)
                  .pages
                  .add(NoteEditingController(note: Note.createdNote("!ViewPager")));
            });
          }),
    ));
    return Column(
      children: [
        Visibility(
            visible: !widget.readOnly,
            child: Align(
              alignment: Alignment.topRight,
                child: IconButton(icon: Icon(Icons.more_horiz), onPressed: () {}))),
        SizedBox(
          height: height,
          child: PageView(
            children: children,
          ),
        ),
      ],
    );
  }
}
