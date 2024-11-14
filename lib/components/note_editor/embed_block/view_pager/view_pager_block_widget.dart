import 'package:amphi/models/app.dart';
import 'package:amphi/widgets/menu/popup/custom_popup_menu_route.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/embed_block/view_pager/edit_view_pager_note_dialog.dart';
import 'package:notes/components/note_editor/embed_block/view_pager/edit_view_pager_style.dart';
import 'package:notes/components/note_editor/embed_block/view_pager/view_pager_data.dart';
import 'package:notes/components/note_editor/embed_block/view_pager/view_pager_page.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/models/note.dart';
import 'package:notes/models/note_embed_blocks.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ViewPagerBlockWidget extends StatefulWidget {
  final String viewPagerKey;
  final bool readOnly;

  const ViewPagerBlockWidget({super.key, required this.viewPagerKey, required this.readOnly});

  @override
  State<ViewPagerBlockWidget> createState() => _ViewPagerBlockWidgetState();
}

class _ViewPagerBlockWidgetState extends State<ViewPagerBlockWidget> {

  int focusingPageIndex = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    ViewPagerData viewPagerData = noteEmbedBlocks.getViewPager(widget.viewPagerKey);
    List<Widget> children = [];
    for(NoteEditingController noteEditingController in viewPagerData.pages) {
      noteEditingController.readOnly = true;
        children.add(
            ViewPagerPage(noteEditingController: noteEditingController, readOnly: widget.readOnly)
        );
    }

    if(!widget.readOnly) {
      children.add(Center(
        child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                noteEmbedBlocks.getViewPager(widget.viewPagerKey).pages.add(NoteEditingController(note: Note.subNote()));
              });
            }),
      ));
    }

    return Column(
      children: [
        Visibility(
            visible: !widget.readOnly,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: focusingPageIndex != viewPagerData.pages.length,
                  child: IconButton(icon: Icon(Icons.edit), onPressed: () {
                    showDialog(context: context, builder: (context) => EditViewPagerNoteDialog(noteEditingController: viewPagerData.pages[focusingPageIndex]));
                  }),
                ),
                IconButton(icon: Icon(Icons.more_horiz), onPressed: () {
                  EditViewPagerStyle editViewPageStyle = EditViewPagerStyle(
                    style: viewPagerData.style,
                    onStyleChanged: (key, data) {
                      setState(() {
                        noteEmbedBlocks.getViewPager(widget.viewPagerKey).style[key] = data;
                      });
                    },
                  );
                  if(App.isWideScreen(context)) {
                    final RenderBox button = context.findRenderObject() as RenderBox;
                    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                    final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);

                    RelativeRect relativeRect = RelativeRect.fromLTRB(
                      1,
                      position.dy + 50,
                      0,
                      0,
                    );
                    showCustomPopupMenuByPosition(context, relativeRect , editViewPageStyle);
                  }
                  else {
                    showDialog(context: context, builder: (context) {
                      return Dialog(
                        child: editViewPageStyle,
                      );
                    });
                  }
                }),
              ],
            )),
        SizedBox(
          height: viewPagerData.style["height"] ?? 250,
          child: PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                focusingPageIndex = index;
              });
            },
            children: children,
          ),
        ),
        MouseRegion(
            cursor: SystemMouseCursors.basic,
            child: SmoothPageIndicator(
              controller: pageController,
              count: viewPagerData.pages.length,
            onDotClicked: (index) {
                pageController.animateToPage(index, duration: Duration(milliseconds: 1000), curve: Curves.easeOutQuint);
            },
              effect: WormEffect(
                dotColor: Theme.of(context).dividerColor,
                activeDotColor: Theme.of(context).highlightColor,
                dotHeight: 15,
                dotWidth: 15,
              ),
            )
        )
      ],
    );
  }
}
