import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:amphi/extensions/color_extension.dart';
import 'package:amphi/utils/file_name_utils.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:amphi/utils/random_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/components/note_editor/embed_block/audio/audio_block_embed.dart';
import 'package:notes/components/note_editor/embed_block/image/image_block_embed.dart';
import 'package:notes/components/note_editor/embed_block/video/video_block_embed.dart';
import 'package:notes/database/database_helper.dart';
import 'package:notes/database/note_queries.dart';
import 'package:notes/extensions/note_extension.dart';
import 'package:notes/models/table_data.dart';

import '../components/note_editor/embed_block/table/note_table_block_embed.dart';
import 'app_storage.dart';

class Note {
  String id;
  String title = "";
  String subtitle = "";
  String longSubtitle = "";
  String? thumbnailImageFilename;
  Color? backgroundColor;
  Color? textColor;
  double? textSize;
  double? lineHeight;
  String parentId = "";
  DateTime modified = DateTime.now();
  DateTime created = DateTime.now();
  DateTime? deleted;
  List<Map<String, dynamic>> content = [];

  bool isFolder = false;
  Delta delta = Delta();
  Map<String, TableData> tables = {};

  Note(
      {required this.id,
      this.title = "",
      this.subtitle = "",
      this.longSubtitle = "",
      this.thumbnailImageFilename,
      this.backgroundColor,
      this.textColor,
      this.textSize,
      this.lineHeight,
      this.parentId = "",
      DateTime? modified,
      DateTime? created,
      this.deleted,
      this.content = const []}) {
    initDelta();
  }

  Note.fromMap(Map<String, dynamic> data) : id = data["id"] {
    if (data["content"] is String) {
      var decoded = jsonDecode(data["content"]);
      if (decoded is List<dynamic>) {
        content = decoded.map((e) => e as Map<String, dynamic>).toList();
      }
    }

    title = data["title"] ?? "";
    subtitle = data["subtitle"] ?? "";
    isFolder = data["is_folder"] == 1;
    created = DateTime.fromMillisecondsSinceEpoch(data["created"]).toLocal();
    modified = DateTime.fromMillisecondsSinceEpoch(data["modified"]).toLocal();
    parentId = data["parent_id"] ?? "";

    if (!isFolder) {
      initTitles();
      initDelta();
    }
  }

  static Note subNote(Note parent) {
    return Note(id: "");
  }

  String generatedKey(Map map) {
    String key = randomString(9, 3);
    if (map.containsKey(key)) {
      return generatedKey(map);
    } else {
      return key;
    }
  }

  Future<void> delete({bool upload = true}) async {
    var images = Directory(PathUtils.join(appStorage.attachmentsPath, id[0], id[1], "images"));
    var videos = Directory(PathUtils.join(appStorage.attachmentsPath, id[0], id[1], "videos"));
    var audio = Directory(PathUtils.join(appStorage.attachmentsPath, id[0], id[1], "audio"));
    if (await images.exists()) {
      images.delete(recursive: true);
    }
    if (await videos.exists()) {
      videos.delete(recursive: true);
    }

    if (await audio.exists()) {
      audio.delete(recursive: true);
    }

    if (upload) {
      appWebChannel.deleteNote(note: this);
    }
  }

  Future<void> moveToTrashIfOrphan() async {}

  List<Map<String, dynamic>> contentsToMap() {
    List<Map<String, dynamic>> contentList = [];

    // for (int i = 0; i < content.length; i++) {
    //   contentList.add(content[i].toMap());
    // }
    return contentList;
  }

  List<Map<String, dynamic>> convertContentsDataToBase64(List<dynamic> list) {
    List<Map<String, dynamic>> result = [];
    for (Map<String, dynamic> map in list) {
      switch (map["type"]) {
        case "img":
          var fileType = FilenameUtils.extensionName(map["value"]);
          result.add({"type": "img", "value": "!BASE64;$fileType;${base64FromSomething(map["value"], "images")}"});
        case "video":
          var fileType = FilenameUtils.extensionName(map["value"]);
          result.add({"type": "video", "value": "!BASE64;$fileType;${base64FromSomething(map["value"], "videos")}"});
        case "table":
          List<List<Map<String, dynamic>>> tableData = [];
          for (List<Map<String, dynamic>> rows in map["value"]) {
            List<Map<String, dynamic>> addingRows = [];
            for (var data in rows) {
              if (data["img"] != null) {
                var fileType = FilenameUtils.extensionName(data["img"]);
                addingRows.add({"img": "!BASE64;$fileType;${base64FromSomething(data["img"], "images")}"});
              } else if (data["video"] != null) {
                var fileType = FilenameUtils.extensionName(data["video"]);
                addingRows.add({"img": "!BASE64;$fileType;${base64FromSomething(data["video"], "videos")}"});
              } else {
                addingRows.add(data);
              }
            }
            tableData.add(addingRows);
          }
          result.add({"type": "table", "value": tableData, "style": map["style"]});
        case "note":
          result.add({
            "type": "note",
            "value": {"title": map["value"]["title"], "contents": convertContentsDataToBase64(map["value"]["contents"])},
            "style": map["style"]
          });
        case "view-pager":
          List<Map<String, dynamic>> viewPagerData = [];
          for (Map<String, dynamic> data in map["value"]) {
            viewPagerData.add({
              "backgroundColor": data["backgroundColor"],
              "textSize": data["textSize"],
              "textColor": data["textColor"],
              "lineHeight": data["lineHeight"],
              "contents": convertContentsDataToBase64(data["contents"] ?? [])
            });
          }
          result.add({"type": "view-pager", "value": viewPagerData, "style": map["style"]});
        default:
          result.add(map);
      }
    }
    return result;
  }

  String toFileContentBase64() {
    Map<String, dynamic> jsonData = {
      "parent_id": parentId,
      "created": created.toUtc().millisecondsSinceEpoch,
      "modified": modified.toUtc().millisecondsSinceEpoch,
      "contents": convertContentsDataToBase64(contentsToMap())
    };
    if (backgroundColor != null) {
      jsonData.addAll({"backgroundColor": backgroundColor!.toHex()});
    }
    if (textColor != null) {
      jsonData.addAll({"textColor": textColor!.toHex()});
    }
    if (deleted != null) {
      jsonData.addAll({"deleted": deleted!.toUtc().millisecondsSinceEpoch});
    }

    String fileContent = jsonEncode(jsonData);
    return fileContent;
  }

  Future<void> save({bool upload = true}) async {
    final database = await databaseHelper.database;
    await database.insertNote(this);

    if (upload) {
      appWebChannel.uploadNote(this);
    }
  }

  void initTitles() {
    title = "";
    subtitle = "";
    longSubtitle = "";
    thumbnailImageFilename = null;

    for (var item in content) {
      if (item["type"] == "text" && item["value"] is String) {
        List<String> textLines = item["value"].split("\n");
        if (textLines.length > 1) {
          for (String line in textLines) {
            if (line.trim().isNotEmpty) {
              if (title.isEmpty) {
                title = line;
              } else {
                if (subtitle.isEmpty) {
                  subtitle = line;
                }
                if (longSubtitle.length < 500) {
                  longSubtitle += line + "\n";
                }
              }
            }
          }
        } else {
          if (item["value"].trim().isNotEmpty) {
            if (title.isEmpty) {
              title = item["value"];
            } else {
              if (subtitle.isEmpty) {
                subtitle = item["value"];
              }
              if (longSubtitle.length < 500) {
                longSubtitle += item["value"] + "\n";
              }
            }
          }
        }
      }
      if (thumbnailImageFilename == null) {
        if (item["type"] == "img") {
          thumbnailImageFilename = item["value"];
        }
      }
      if (thumbnailImageFilename != null && title.isNotEmpty && subtitle.isNotEmpty && longSubtitle.length > 500) {
        break;
      }
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": isFolder ? title : null,
      "subtitle": null,
      "background_color": backgroundColor?.value,
      "text_color": textColor?.value,
      "text_size": textSize?.toInt(),
      "line_height": lineHeight?.toInt(),
      "parent_id": parentId.isEmpty ? null : parentId,
      "modified": modified.toUtc().millisecondsSinceEpoch,
      "created": created.toUtc().millisecondsSinceEpoch,
      "deleted": deleted?.toUtc().millisecondsSinceEpoch,
      "content": content,
      "is_folder": isFolder,
      "background": null
    };
  }

  Color? textColorByTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? textColor?.inverted() : textColor;
  }

  Color backgroundColorByTheme(BuildContext context) {
    return (Theme.of(context).brightness == Brightness.dark ? backgroundColor?.inverted() : backgroundColor) ?? Theme.of(context).cardColor;
  }

  void initDelta() {
    delta = Delta();
    tables.clear();
    for (var item in content) {
      delta.insertContent(this, item);
    }

    if (delta.isEmpty) {
      delta.insert("\n");
    }

    if (!delta.last.data.toString().endsWith('\n')) {
      delta.insert("\n");
    }
  }
}

extension DeltaExtension on Delta {
  void insertContent(Note note, Map<String, dynamic> item) {
    switch (item["type"]) {
      case "img":
        BlockEmbed blockEmbed = BlockEmbed.custom(ImageBlockEmbed(item["value"]));
        insert(blockEmbed.toJson());
        break;
      case "video":
        BlockEmbed blockEmbed = BlockEmbed.custom(VideoBlockEmbed(item["value"]));
        insert(blockEmbed.toJson());
        break;
      case "table":
        final id = note.generatedKey(note.tables);

        note.tables[id] = TableData.fromMap(item);
        BlockEmbed blockEmbed = BlockEmbed.custom(NoteTableBlockEmbed(id));
        insert(blockEmbed.toJson());
        break;
      case "audio":
        BlockEmbed blockEmbed = BlockEmbed.custom(AudioBlockEmbed(item["value"]));
        insert(blockEmbed.toJson());
        break;

      // Convert old sub-notes to regular notes
      // The sub-note feature was time-consuming to develop and didn't seem useful for most users, so it has been removed.
      case "note":
        final subNoteData = item["value"];
        if (subNoteData is Map<String, dynamic>) {
          final subNoteTitle = subNoteData["title"];
          final subNoteContent = subNoteData["contents"];
          if (subNoteTitle is String) {
            insert(subNoteTitle);
            insert("\n");
          } else {
            insert(subNoteTitle.toString());
          }

          if (subNoteContent is List<dynamic>) {
            for (var subNoteItem in subNoteContent) {
              insertContent(note, subNoteItem);
            }
          } else {
            insert(subNoteContent.toString());
          }
        }
        break;
      // case "divider":
      //   String dividerKey = noteEmbedBlocks.generatedDividerKey();
      //   if (content.style != null) {
      //     noteEmbedBlocks.dividers[dividerKey] = Color(content.style!["color"] ?? 0);
      //   }
      //   BlockEmbed divider = BlockEmbed.custom(DividerBlockEmbed(dividerKey));
      //   delta.insert(divider.toJson());
      //
      //   break;
      // case "view-pager":
      //   String viewPagerKey = noteEmbedBlocks.generatedViewPagerKey();
      //   noteEmbedBlocks.viewPagers[viewPagerKey] = ViewPagerData.fromContent(this, content);
      //   BlockEmbed blockEmbed = BlockEmbed.custom(ViewPagerBlockEmbed(viewPagerKey));
      //   delta.insert(blockEmbed.toJson());
      //   break;
      // case "file":
      //   var key = noteEmbedBlocks.generatedFileKey();
      //   noteEmbedBlocks.files[key] = FileInNote.fromContent(content);
      //   BlockEmbed blockEmbed = BlockEmbed.custom(FileBlockEmbed(key));
      //   delta.insert(blockEmbed.toJson());
      //   break;
      case "text":
        if (item["value"] is String) {
          // if(!item["value"].endsWith("\n")) {
          //   item["value"] = item["value"] + "\n";
          // }
          // String text = item["value"];

          insert(item["value"], item["style"]);
          break;
        }

      default:
        // if(!item["value"].toString().endsWith("\n")) {
        //   item["value"] = item["value"].toString() + "\n";
        // }
        insert(item["value"].toString());

        break;
    }
  }
}
