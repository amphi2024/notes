import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:amphi/extensions/color_extension.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:amphi/utils/random_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/components/note_editor/embed_block/audio/audio_block_embed.dart';
import 'package:notes/components/note_editor/embed_block/image/image_block_embed.dart';
import 'package:notes/components/note_editor/embed_block/video/video_block_embed.dart';
import 'package:notes/database/database_helper.dart';
import 'package:notes/database/note_queries.dart';
import 'package:notes/models/table_data.dart';
import 'package:notes/utils/attachment_path.dart';
import 'package:notes/utils/generate_id.dart';

import '../components/note_editor/embed_block/divider/divider_block_embed.dart';
import '../components/note_editor/embed_block/file/file_block_embed.dart';
import '../components/note_editor/embed_block/table/note_table_block_embed.dart';
import 'app_storage.dart';
import 'file_model.dart';

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
  String? background;
  DateTime modified = DateTime.now();
  DateTime created = DateTime.now();
  DateTime? deleted;
  List<Map<String, dynamic>> content = [];

  bool isFolder = false;
  Delta delta = Delta();
  Map<String, TableData> tables = {};
  Map<String, Color> dividerColors = {};
  Map<String, FileModel> files = {};

  Note(
      {required this.id,
      this.title = "",
      this.subtitle = "",
      this.longSubtitle = "",
      this.thumbnailImageFilename,
      this.backgroundColor,
      this.background,
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
    if (data["deleted"] is int) {
      deleted = DateTime.fromMillisecondsSinceEpoch(data["deleted"]).toLocal();
    }

    int? text_size = data["text_size"];
    if (text_size != null) {
      textSize = text_size.toDouble();
    }

    int? text_color = data["text_color"];
    if (text_color != null) {
      textColor = Color(text_color);
    }
    int? line_height = data["line_height"];
    if (line_height != null) {
      lineHeight = line_height.toDouble();
    }
    int? background_color = data["background_color"];
    if (background_color != null) {
      backgroundColor = Color(background_color);
    }
    background = data["background"];

    if (!isFolder) {
      initTitles();
      initDelta();
    }
  }

  String generatedKey(Map map) {
    String key = randomString(9, 3);
    if (map.containsKey(key)) {
      return generatedKey(map);
    } else {
      return key;
    }
  }

  Future<void> delete({bool upload = true, required WidgetRef ref}) async {
    if (id.isEmpty) {
      return;
    }
    final database = await databaseHelper.database;
    await database.deleteNoteById(id, ref);
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

  Future<void> save({bool upload = true}) async {
    print(id);
    if (id.isEmpty) {
      id = await generatedNoteId();
    }
    final database = await databaseHelper.database;
    await database.insertNote(this);

    final Set<String> images = {};
    final Set<String> videos = {};
    final Set<String> audio = {};
    for(var item in content) {
      switch(item["type"]) {
        case "img":
          images.add(noteImagePath(id, item["value"]));
          break;
        case "video":
          videos.add(noteVideoPath(id, item["value"]));
          break;
        case "audio":
          audio.add(noteAudioPath(id, item["value"]));
          break;
      }
    }
    await deleteObsoleteAttachments(images, "images");
    await deleteObsoleteAttachments(videos, "videos");
    await deleteObsoleteAttachments(audio, "audio");

    if (upload) {
      appWebChannel.uploadNote(this);
    }
  }

  Future<void> deleteObsoleteAttachments(Set<String> filePaths, String directoryName) async {
    final directory = Directory(noteAttachmentDirPath(id, directoryName));
    Set<String> existingFilePaths = {};
    if (await directory.exists()) {
      final fileList = await directory.list().toList();
      for(var i = 0; i < await fileList.length; i++) {
        final file = fileList[i];
        existingFilePaths.add(file.path);
      }

      final obsoleteFilePaths = existingFilePaths.difference(filePaths).toList();

      for(var filePath in obsoleteFilePaths) {
        final file = File(filePath);
        await file.delete();
      }
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
      "background_color": backgroundColor?.toARGB32(),
      "text_color": textColor?.toARGB32(),
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
    dividerColors.clear();
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
      case "divider":
        BlockEmbed blockEmbed = BlockEmbed.custom(DividerBlockEmbed(""));
        insert(blockEmbed.toJson());
        break;
      case "file":
        final filename = item["value"]?["filename"];
        if(filename != null) {

          note.files[filename] = FileModel(filename: filename, label: item["value"]?["label"] ?? "");

          BlockEmbed blockEmbed = BlockEmbed.custom(FileBlockEmbed(filename));
          insert(blockEmbed.toJson());
        }
        break;
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
