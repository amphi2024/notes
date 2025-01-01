

import 'package:amphi/utils/file_name_utils.dart';
import 'package:notes/extensions/note_extension.dart';
import 'package:notes/models/note.dart';

class Content {
  dynamic value = "";
  String type = "text";
  Map<String, dynamic>? style = {};

  Content({this.value = "", this.type = "text", this.style = const {} });

  @override
  String toString() {
    return """
    {
      value: $value,
      type: $type,
      style: $style
      }
    """;
  }

  static Content fromMap(Map<String, dynamic> map) {
    switch (map["type"]) {
      case "img":
        return Content(value: map["value"], type: "img");
      case "video":
        return Content(value: map["value"], type: "video");
      case "table":
        return Content(value: map["value"], type: "table", style: map["style"]);
      case "note":
        return Content(value: map["value"], type: "note");
      case "divider":
        return Content(style: map["style"], type: "divider");
      case "view-pager":
        return Content(value: map["value"] , style: map["style"], type: "view-pager");
      case "file":
        return Content(value: map["value"] , type: "file");
      default:
       // return Content(value: map["value"], type: "text", style: styleFromData(map));
         return Content(value: map["value"], type: "text", style: map["style"]);
    }
  }

  Map<String, dynamic> toMap() {
    return {"value": value, "type": type, "style": style};
  }

  Map<String, dynamic> toBase64Map(Note note) {
    switch (type) {
      case "img":
        var fileType = FilenameUtils.extensionName(value);
        return {
          "type": "img",
          "value": "!BASE64;$fileType;${note.base64FromSomething(value, "images")}"
        };
      case "video":
        var fileType = FilenameUtils.extensionName(value);
        return {
          "type": "video",
          "value": "!BASE64;$fileType;${note.base64FromSomething(value, "videos")}"
        };
      case "table":
        return {
          "type": "table",
          "value": (value as List<List<Map<String, dynamic>>>).toBase64ValueData(note),
          "style": style
        };
      case "note":
        Map<String, dynamic> map = value;
        return {
          "type": "note",
          "value": map.toBase64SubNoteData(note)
        };

      default:
        return toMap();
    }
  }
}

extension SubNoteExtension on Map<String, dynamic> {
  Map<String, dynamic> toBase64SubNoteData(Note note) {
    List<Map<String, dynamic>> contents = [];
    for(Map<String, dynamic> map in this["contents"]) {

    }
    return {
      "title": this["title"],
      "contents": contents
    };
  }
}

extension TableDataExtension on List<List<Map<String, dynamic>>> {
   List<List<Map<String, dynamic>>> toBase64ValueData(Note note) {
     List<List<Map<String, dynamic>>> tableData = [];
     for(List<Map<String, dynamic>> rows in this) {
       List<Map<String, dynamic>> addingRows = [];
       for(var data in rows) {
         if(data.containsKey("img")) {
           var fileType = FilenameUtils.extensionName(data["img"]);
           addingRows.add({
             "img": "!BASE64;$fileType;${note.base64FromSomething(data["img"], "images")}"
           });
         }
         else if(data.containsKey("video")) {
           var fileType = FilenameUtils.extensionName(data["video"]);
           addingRows.add({
             "video": "!BASE64;$fileType;${note.base64FromSomething(data["video"], "videos")}"
           });
         }
         else {
           addingRows.add(data);
         }
       }
       tableData.add(addingRows);
     }
     return tableData;
   }
}