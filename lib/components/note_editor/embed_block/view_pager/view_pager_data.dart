import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/models/content.dart';
import 'package:notes/models/note.dart';

class ViewPagerData {
  List<NoteEditingController> pages = [];
  Map<String, dynamic> style = {
    "height" : 250.0
  };

  Content toContent() {
    List<Map<String, dynamic>> children = [];
    for(NoteEditingController noteEditingController in pages) {
      Note note = noteEditingController.getNote();

      Map<String, dynamic> map = {};
      if(note.backgroundColor != null) {
        map["backgroundColor"] = note.backgroundColor;
      }
      if(note.textSize != null) {
        map["textSize"] = note.textSize;
      }
      if(note.textColor != null) {
        map["textColor"] = note.textColor;
      }
      if(note.lineHeight != null) {
        map["lineHeight"] = note.lineHeight;
      }
      map["contents"] = note.contentsToMap();
      children.add(map);
    }

    return Content(
      value: children,
      style: style,
      type: "view-pager"
    );
  }

  static ViewPagerData fromContent(Note parent, Content content) {
    ViewPagerData viewPagerData = ViewPagerData();
    try {
      viewPagerData.style = content.style ?? {};
      List<Map<String, dynamic>> list = (content.value as List).map((item) => item as Map<String, dynamic>).toList();
      for(Map<String, dynamic> map in list) {
        Note note = Note.subNote(parent);
        note.backgroundColor = map["backgroundColor"];
        note.textSize = map["textSize"];
        note.textColor = map["textColor"];
        note.lineHeight = map["lineHeight"];
        note.backgroundColor = map["backgroundColor"];

        List<Map<String, dynamic>> contentMapList = (map["contents"] as List).map((item) => item as Map<String, dynamic>).toList();
        contentMapList.forEach((contentMap) {
          note.contents.add(Content.fromMap(contentMap));
        });

        viewPagerData.pages.add(NoteEditingController(note: note));
      }
    }
    catch(e) {
      viewPagerData.pages = [];
    }

    return viewPagerData;
  }
}