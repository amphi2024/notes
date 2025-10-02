import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:ui';

import 'package:amphi/extensions/color_extension.dart';
import 'package:amphi/utils/file_name_utils.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/components/note_editor/embed_block/divider/divider_block_embed.dart';
import 'package:notes/components/note_editor/embed_block/file/file_block_embed.dart';
import 'package:notes/components/note_editor/embed_block/image/image_block_embed.dart';
import 'package:notes/components/note_editor/embed_block/sub_note/sub_note_block_embed.dart';
import 'package:notes/components/note_editor/embed_block/table/note_table_block_embed.dart';
import 'package:notes/components/note_editor/embed_block/table/table/table_data.dart';
import 'package:notes/components/note_editor/embed_block/video/video_block_embed.dart';
import 'package:notes/components/note_editor/embed_block/view_pager/view_pager_block_embed.dart';
import 'package:notes/components/note_editor/embed_block/view_pager/view_pager_data.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/extensions/note_extension.dart';

import 'package:notes/models/content.dart';
import 'package:notes/models/file_in_note.dart';
import 'package:notes/models/note_embed_blocks.dart';

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
  String? font;
  String parentId = "";
  DateTime modified = DateTime.now();
  DateTime created = DateTime.now();
  DateTime? deleted;

  Note({required this.id});

  List<Map<String, dynamic>> content = [];

  Future<File> createdFileWithBase64(String base64, String fileExtension ,String directoryName) async {
    Directory directory = Directory(PathUtils.join(appStorage.notesPath, id[0], id[1], directoryName));
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }

    String generatedImageFilename = FilenameUtils.generatedFileName(fileExtension, directory.path);

    File file = File(PathUtils.join(directory.path, generatedImageFilename));
    await file.writeAsBytes(base64Decode(base64));

    return file;
  }

  Future<File> createdFile(String originalPath, String directoryName) async {
    Directory directory = Directory(PathUtils.join(appStorage.notesPath, id[0], id[1], directoryName));
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }

    String generatedImageFilename = FilenameUtils.generatedFileName(PathUtils.extension(originalPath), directory.path);

    File originalFile = File(originalPath);
    File file = File(PathUtils.join(directory.path, generatedImageFilename));
    await originalFile.copy(file.path);

    return file;
  }

  Future<File> createdImageFile(String originalPath) async => createdFile(originalPath, "images");

  Future<File> createdVideoFile(String originalPath) async => createdFile(originalPath, "videos");

  Future<File> createdImageFileWithBase64(String base64, String fileExtension) async => createdFileWithBase64(base64, fileExtension , "images");

  Future<File> createdVideoFileWithBase64(String base64, String fileExtension) async => createdFileWithBase64(base64, fileExtension , "videos");

  static Note subNote(Note parent) {
    return Note(id: "");
  }

  Document toDocument() {
    Delta delta = Delta();
    // for (Content content in content) {
    //   switch (content.type) {
    //     case "img":
    //       BlockEmbed blockEmbed = BlockEmbed.custom(ImageBlockEmbed(content.value));
    //       delta.insert(blockEmbed.toJson());
    //       break;
    //     case "video":
    //       BlockEmbed blockEmbed = BlockEmbed.custom(VideoBlockEmbed(content.value));
    //       delta.insert(blockEmbed.toJson());
    //       break;
    //     case "table":
    //       String tableKey = noteEmbedBlocks.generatedTableKey();
    //       noteEmbedBlocks.tables[tableKey] = TableData.fromContent(content);
    //       BlockEmbed blockEmbed = BlockEmbed.custom(NoteTableBlockEmbed(tableKey));
    //       delta.insert(blockEmbed.toJson());
    //       break;
    //     case "note":
    //       Map<String, dynamic> subNoteData = content.value;
    //
    //       Note subNote = Note.subNote(this);
    //       subNote.title = subNoteData["title"] ?? "";
    //       for (dynamic data in subNoteData["contents"] ?? []) {
    //         Map<String, dynamic> map = data;
    //         subNote.content.add(Content(map));
    //       }
    //
    //       String subNoteKey = noteEmbedBlocks.generatedSubNoteKey();
    //       noteEmbedBlocks.subNotes[subNoteKey] = NoteEditingController(note: subNote, readOnly: true);
    //       BlockEmbed blockEmbed = BlockEmbed.custom(SubNoteBlockEmbed(subNoteKey));
    //       delta.insert(blockEmbed.toJson());
    //
    //       break;
    //     case "divider":
    //       String dividerKey = noteEmbedBlocks.generatedDividerKey();
    //       if (content.style != null) {
    //         noteEmbedBlocks.dividers[dividerKey] = Color(content.style!["color"] ?? 0);
    //       }
    //       BlockEmbed divider = BlockEmbed.custom(DividerBlockEmbed(dividerKey));
    //       delta.insert(divider.toJson());
    //
    //       break;
    //     case "view-pager":
    //       String viewPagerKey = noteEmbedBlocks.generatedViewPagerKey();
    //       noteEmbedBlocks.viewPagers[viewPagerKey] = ViewPagerData.fromContent(this, content);
    //       BlockEmbed blockEmbed = BlockEmbed.custom(ViewPagerBlockEmbed(viewPagerKey));
    //       delta.insert(blockEmbed.toJson());
    //       break;
    //     case "file":
    //       var key = noteEmbedBlocks.generatedFileKey();
    //       noteEmbedBlocks.files[key] = FileInNote.fromContent(content);
    //       BlockEmbed blockEmbed = BlockEmbed.custom(FileBlockEmbed(key));
    //       delta.insert(blockEmbed.toJson());
    //       break;
    //     case "text":
    //       if (content.value is String) {
    //         // if(!content.value.endsWith("\n")) {
    //         //   content.value = content.value + "\n";
    //         // }
    //         // String text = content.value;
    //
    //         delta.insert(content.value, content.style);
    //         break;
    //       }
    //
    //
    //     default:
    //       // if(!content.value.toString().endsWith("\n")) {
    //       //   content.value = content.value.toString() + "\n";
    //       // }
    //       delta.insert(content.value.toString());
    //
    //       break;
    //   }
    // }

    if (delta.isEmpty) {
      delta.insert("\n");
    }

    if (!delta.last.data.toString().endsWith('\n')) {
      delta.insert("\n");
    }

    return Document.fromDelta(delta);
  }

  Future<void> delete({bool upload = true}) async {
    var images = Directory(PathUtils.join(appStorage.notesPath, id[0], id[1], "images"));
    var videos = Directory(PathUtils.join(appStorage.notesPath, id[0], id[1], "videos"));
    var audio = Directory(PathUtils.join(appStorage.notesPath, id[0], id[1], "audio"));
    if(await images.exists()) {
      images.delete(recursive: true);
    }
    if(await videos.exists()) {
      videos.delete(recursive: true);
    }

    if(await audio.exists()) {
      audio.delete(recursive: true);
    }

    if (upload) {
      appWebChannel.deleteNote(note: this);
    }
  }

  Future<void> moveToTrashIfOrphan() async {

  }

  List<Map<String, dynamic>> contentsToMap() {
    List<Map<String, dynamic>> contentList = [];

    // for (int i = 0; i < content.length; i++) {
    //   contentList.add(content[i].toMap());
    // }
    return contentList;
  }

  List<Map<String, dynamic>> convertContentsDataToBase64(List<dynamic> list) {
    List<Map<String, dynamic>> result = [];
    for(Map<String, dynamic> map in list) {
      switch(map["type"]) {
        case "img":
          var fileType = FilenameUtils.extensionName(map["value"]);
          result.add({
            "type": "img",
            "value": "!BASE64;$fileType;${base64FromSomething(map["value"], "images")}"
          });
        case "video":
          var fileType = FilenameUtils.extensionName(map["value"]);
          result.add({
            "type": "video",
            "value": "!BASE64;$fileType;${base64FromSomething(map["value"], "videos")}"
          });
        case "table":
          List<List<Map<String, dynamic>>> tableData = [];
          for(List<Map<String, dynamic>> rows in map["value"]) {
            List<Map<String, dynamic>> addingRows = [];
            for(var data in rows) {
              if(data["img"] != null) {
                var fileType = FilenameUtils.extensionName(data["img"]);
                addingRows.add({
                  "img": "!BASE64;$fileType;${base64FromSomething(data["img"], "images")}"
                });
              }
              else if(data["video"] != null) {
                var fileType = FilenameUtils.extensionName(data["video"]);
                addingRows.add({
                  "img": "!BASE64;$fileType;${base64FromSomething(data["video"], "videos")}"
                });
              }
              else {
                addingRows.add(data);
              }
            }
            tableData.add(addingRows);
          }
          result.add({
            "type": "table",
            "value": tableData,
            "style": map["style"]
          });
        case "note":
          result.add({
            "type": "note",
            "value": {
              "title": map["value"]["title"],
              "contents": convertContentsDataToBase64(map["value"]["contents"])
            },
            "style": map["style"]
          });
        case "view-pager":
          List<Map<String, dynamic>> viewPagerData = [];
          for(Map<String, dynamic> data in map["value"]) {
            viewPagerData.add({
              "backgroundColor": data["backgroundColor"],
              "textSize": data["textSize"],
              "textColor": data["textColor"],
              "lineHeight": data["lineHeight"],
              "contents": convertContentsDataToBase64( data["contents"] ?? [])
            });
          }
          result.add({
            "type": "view-pager",
            "value": viewPagerData,
            "style": map["style"]
          });
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

  }

  Future<void> saveDraft() async {

  }

  void initTitles() {
    title = "";
    subtitle = "";
    longSubtitle = "";
    thumbnailImageFilename = null;

    // for (Content content in content) {
    //   if (content.type == "text" && content.value is String) {
    //     List<String> textLines = content.value.split("\n");
    //     if (textLines.length > 1) {
    //       for (String line in textLines) {
    //         if (line.trim().isNotEmpty) {
    //           if (title.isEmpty) {
    //             title = line;
    //           } else {
    //             if (subtitle.isEmpty) {
    //               subtitle = line;
    //             }
    //             if(longSubtitle.length < 500) {
    //               longSubtitle += line + "\n";
    //             }
    //           }
    //         }
    //       }
    //     } else {
    //       if (content.value.trim().isNotEmpty) {
    //         if (title.isEmpty) {
    //           title = content.value;
    //         } else {
    //           if (subtitle.isEmpty) {
    //           subtitle = content.value;
    //           }
    //           if(longSubtitle.length < 500) {
    //             longSubtitle += content.value + "\n";
    //           }
    //         }
    //       }
    //     }
    //   }
    //   if (thumbnailImageFilename == null) {
    //     if (content.type == "img") {
    //       thumbnailImageFilename = content.value;
    //     }
    //   }
    //   if (thumbnailImageFilename != null && title.isNotEmpty && subtitle.isNotEmpty && longSubtitle.length > 500) {
    //     break;
    //   }
    // }

  }

  Color? textColorByTheme(bool darkMode) {
    return darkMode ? textColor?.inverted() : textColor;
  }

  Color? backgroundColorByTheme(bool darkMode) {
    return darkMode ? backgroundColor?.inverted() : backgroundColor;
  }

}