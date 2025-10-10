import 'dart:convert';

import 'package:amphi/utils/path_utils.dart';
import 'package:flutter_quill/flutter_quill.dart';

extension DocumentConversion on Document {
  List<Map<String, dynamic>> toNoteContent() {
    List<Map<String, dynamic>> content = [];

    for(var operation in toDelta().toList()) {
      // switch(operation.value.runtimeType) {
      //   case Map:
      //     print(operation.value["custom"]);
      //   case String:
      //     content.add({"value": operation.value, "type": "text", "style": operation.attributes});
      //   default:
      //     print(operation.value.runtimeType);
      // }
          if (operation.value is String) {
      content.add({"value": operation.value, "type": "text", "style": operation.attributes});
    } else {
      Map<String, dynamic> blockData = jsonDecode(operation.value["custom"]);
      if (blockData.containsKey("image")) {
        String path = blockData["image"];
        content.add({"value": PathUtils.basename(path), "type": "img"});
      } else if (blockData.containsKey("video")) {
        String path = blockData["video"];
        content.add({"value": PathUtils.basename(path), "type": "video"});
      }
      // else if (blockData.containsKey("table")) {
      //   String key = blockData["table"];
      //   TableData tableData = noteEmbedBlocks.getTable(key);
      //
      //   content.add({"value": tableData.data, "type": "table", "style": {
      //     "pages": tableData.pages,
      //   }));
      // } else if (blockData.containsKey("note")) {
      //   String key = blockData["note"];
      //   content.add({
      //       "value": {"title": noteEmbedBlocks.getSubNote(key).note.title, "contents": noteEmbedBlocks.getSubNote(key).getNote().contentsToMap()},
      //       "type": "note"});
      // } else if (blockData.containsKey("divider")) {
      //   String key = blockData["divider"];
      //   Color? color = noteEmbedBlocks.dividers[key];
      //   if (color != null) {
      //     content.add({"type": "divider", "style": {"color": color.value}});
      //   } else {
      //     content.add({"type": "divider", "value": null, "style": null});
      //   }
      // }
      // else if(blockData.containsKey("file")) {
      //   String key = blockData["file"];
      //   var fileModel = noteEmbedBlocks.getFile(key);
      //   content.add(fileModel.toContent());
      // }
    }
    }

    return content;
  }
}
// Note getNote() {
//   content = [];
//   for (Operation operation in document.toDelta().toList()) {
//     if (operation.value is String) {
//       content.add({"value": operation.value, "type": "text", "style": operation.attributes));
//     } else {
//       Map<String, dynamic> blockData = jsonDecode(operation.value["custom"]);
//       if (blockData.containsKey("image")) {
//         String path = blockData["image"];
//         content.add({"value": PathUtils.basename(path), "type": "img"));
//       } else if (blockData.containsKey("video")) {
//         String path = blockData["video"];
//         content.add({"value": PathUtils.basename(path), "type": "video"));
//       } else if (blockData.containsKey("table")) {
//         String key = blockData["table"];
//         TableData tableData = noteEmbedBlocks.getTable(key);
//
//         content.add({"value": tableData.data, "type": "table", "style": {
//           "pages": tableData.pages,
//         }));
//       } else if (blockData.containsKey("note")) {
//         String key = blockData["note"];
//         content.add({
//             "value": {"title": noteEmbedBlocks.getSubNote(key).note.title, "contents": noteEmbedBlocks.getSubNote(key).getNote().contentsToMap()},
//             "type": "note"));
//       } else if (blockData.containsKey("divider")) {
//         String key = blockData["divider"];
//         Color? color = noteEmbedBlocks.dividers[key];
//         if (color != null) {
//           content.add({"type": "divider", "style": {"color": color.value}));
//         } else {
//           content.add({"type": "divider", "value": null, "style": null));
//         }
//       } else if (blockData.containsKey("view-pager")) {
//         String key = blockData["view-pager"];
//         ViewPagerData viewPagerData = noteEmbedBlocks.getViewPager(key);
//         content.add(viewPagerData.to{));
//       }
//       else if(blockData.containsKey("file")) {
//         String key = blockData["file"];
//         var fileModel = noteEmbedBlocks.getFile(key);
//         content.add(fileModel.to{));
//       }
//     }
//   }
//
//   return note;
// }