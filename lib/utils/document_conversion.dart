import 'dart:convert';

import 'package:amphi/utils/path_utils.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/providers/note_files_provider.dart';
import 'package:notes/providers/tables_provider.dart';

typedef EmbedHandler = Map<String, dynamic> Function(Map<String, dynamic> data, WidgetRef ref);

final embedHandlers = <String, EmbedHandler>{
  "image": (blockData, ref) => {
    "value": PathUtils.basename(blockData["image"]),
    "type": "img",
  },
  "video": (blockData, ref) => {
    "value": PathUtils.basename(blockData["video"]),
    "type": "video",
  },
  "table": (blockData, ref) {
    final key = blockData["table"];
    final tableData = ref.watch(tablesProvider)[key]!.data();
    return {
      "value": tableData.data,
      "type": "table",
      "style": {"views": tableData.views},
    };
  },
  "divider": (blockData, ref) {
    final value = int.tryParse(blockData["divider"]);
    return {
      "type": "divider",
      "style": value != null ? {"color": value} : null,
    };
  },
  "file": (blockData, ref) {
    final filename = blockData["file"];
    final fileModel = ref.watch(noteFilesProvider)[filename];
    return {
      "value": {"label": fileModel?.label ?? "", "filename": filename},
      "type": "file"
    };
  },
  "audio": (blockData, ref) => {
    "value": PathUtils.basename(blockData["audio"]),
    "type": "audio"
  }
};

extension DocumentConversion on Document {
  List<Map<String, dynamic>> toNoteContent(WidgetRef ref) {
    List<Map<String, dynamic>> content = [];

    for (var operation in toDelta().toList()) {
      final value = operation.value;
      if (value is String) {
        content.add({
          "value": value,
          "type": "text",
          "style": operation.attributes,
        });
        continue;
      }

      final blockData = jsonDecode(value["custom"]) as Map<String, dynamic>;
      final key = blockData.keys.first;
      final handler = embedHandlers[key];

      if (handler != null) {
        content.add(handler(blockData, ref));
      } else {
        //print("Unknown embed type: $key");
      }
    }

    return content;
  }
}