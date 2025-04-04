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
import 'package:notes/channels/app_web_delete.dart';
import 'package:notes/channels/app_web_upload.dart';
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
import 'package:notes/models/app_state.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/content.dart';
import 'package:notes/models/file_in_note.dart';
import 'package:notes/models/item.dart';
import 'package:notes/models/note_embed_blocks.dart';

class Note extends Item {
  String subtitle = "";
  String longSubtitle = "";
  String? thumbnailImageFilename;
  double? textSize;
  double? lineHeight;
  String? font;
  String get name => FilenameUtils.nameOnly(filename);
  String get draftPath => PathUtils.join(appStorage.notesPath, name, "draft.note");

  List<Content> contents;

  Note(
      {required super.filename,
      required super.path,
      required super.location,
      required this.contents,
      required super.created,
      required super.originalCreated,
      required super.modified,
      required super.originalModified,
      super.deleted,
      this.lineHeight,
      this.textSize,
      super.textColor,
        super.backgroundColor}) {
    String filenameWithoutType = FilenameUtils.nameOnly(filename);
    Directory imagesDir = Directory(PathUtils.join(appStorage.notesPath, filenameWithoutType, "images"));
    Directory videosDir = Directory(PathUtils.join(appStorage.notesPath, filenameWithoutType, "videos"));
    if (File(path).existsSync()) {
      if (!imagesDir.existsSync()) {
        imagesDir.create(recursive: true);
      }
      if (!videosDir.existsSync()) {
        videosDir.create(recursive: true);
      }
    }
  }

  void getDraft(void Function(Note?) onExists) async {
    var draftFile = File(draftPath);
    if(await draftFile.exists()) {
      onExists(Note.fromFile(draftFile));
    }
    else {
      onExists(null);
    }
  }

  Future<File> createdFileWithBase64(String base64, String fileExtension ,String directoryName) async {
    String filenameWithoutType = FilenameUtils.nameOnly(filename);
    Directory directory = Directory(PathUtils.join(appStorage.notesPath, filenameWithoutType, directoryName));
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }

    String generatedImageFilename = FilenameUtils.generatedFileName(fileExtension, directory.path);

    File file = File(PathUtils.join(directory.path, generatedImageFilename));
    await file.writeAsBytes(base64Decode(base64));

    return file;
  }

  Future<File> createdFile(String originalPath, String directoryName) async {
    String filenameWithoutType = FilenameUtils.nameOnly(filename);
    Directory directory = Directory(PathUtils.join(appStorage.notesPath, filenameWithoutType, directoryName));
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

  Future<void> deleteObsoleteMediaFiles() async {

    try {
      List<Content> imageOnlyContents = [];
      List<Content> videoOnlyContents = [];
      for(var content in contents) {
        switch(content.type) {
          case "img":
            imageOnlyContents.add(content);
            break;
          case "video":
            videoOnlyContents.add(content);
            break;
        }
      }

      var imagesDirectory = Directory(PathUtils.join(appStorage.notesPath, name , "images"));
      var videosDirectory = Directory(PathUtils.join(appStorage.notesPath, name , "videos"));
      if(await imagesDirectory.exists()) {
        var imageFiles = await imagesDirectory.list().toList();
        for(int i = 0; i < await imageFiles.length; i++) {
          bool exists = false;
          for(int j = 0; j < imageOnlyContents.length; j++) {
            var filename = PathUtils.basename(imageFiles[i].path);
            if(filename == imageOnlyContents[j].value) {
              exists = true;
              imageOnlyContents.removeAt(j);
              break;
            }
          }
          if(!exists) {
            imageFiles[i].delete();
            imageFiles.removeAt(i);
            i--;
          }
        }
      }
      if(await videosDirectory.exists()) {
        var videoFiles = await videosDirectory.list().toList();
        for(int i = 0; i < await videoFiles.length; i++) {
          bool exists = false;
          for(int j = 0; j < videoOnlyContents.length; j++) {
            var filename = PathUtils.basename(videoFiles[i].path);
            if(filename == videoOnlyContents[j].value) {
              exists = true;
              videoOnlyContents.removeAt(j);
              break;
            }
          }
          if(!exists) {
            videoFiles[i].delete();
            videoFiles.removeAt(i);
            i--;
          }
        }
      }
    }
    catch(e) {

    }
  }

  static Note subNote(Note parent) {
    return Note(
        filename: parent.filename,
        path: parent.path,
        location: parent.filename,
        created: DateTime.now(),
        originalCreated: DateTime.now(),
        modified: DateTime.now(),
        originalModified: DateTime.now(),
        contents: []);
  }

  static Note createdNote(String home) {
    String filename = FilenameUtils.generatedFileName(".note", appStorage.notesPath);
    return Note(
        filename: filename,
        path: PathUtils.join(appStorage.notesPath, filename),
        location: home,
        created: DateTime.now(),
        originalCreated: DateTime.now(),
        modified: DateTime.now(),
        originalModified: DateTime.now(),
        contents: []);
  }

  Document toDocument() {
    Delta delta = Delta();
    for (Content content in contents) {
      switch (content.type) {
        case "img":
          BlockEmbed blockEmbed = BlockEmbed.custom(ImageBlockEmbed(content.value));
          delta.insert(blockEmbed.toJson());
          break;
        case "video":
          BlockEmbed blockEmbed = BlockEmbed.custom(VideoBlockEmbed(content.value));
          delta.insert(blockEmbed.toJson());
          break;
        case "table":
          String tableKey = noteEmbedBlocks.generatedTableKey();
          noteEmbedBlocks.tables[tableKey] = TableData.fromContent(content);
          BlockEmbed blockEmbed = BlockEmbed.custom(NoteTableBlockEmbed(tableKey));
          delta.insert(blockEmbed.toJson());
          break;
        case "note":
          Map<String, dynamic> subNoteData = content.value;

          Note subNote = Note.subNote(this);
          subNote.title = subNoteData["title"] ?? "";
          for (dynamic data in subNoteData["contents"] ?? []) {
            Map<String, dynamic> map = data;
            subNote.contents.add(Content.fromMap(map));
          }

          String subNoteKey = noteEmbedBlocks.generatedSubNoteKey();
          noteEmbedBlocks.subNotes[subNoteKey] = NoteEditingController(note: subNote, readOnly: true);
          BlockEmbed blockEmbed = BlockEmbed.custom(SubNoteBlockEmbed(subNoteKey));
          delta.insert(blockEmbed.toJson());

          break;
        case "divider":
          String dividerKey = noteEmbedBlocks.generatedDividerKey();
          if (content.style != null) {
            noteEmbedBlocks.dividers[dividerKey] = Color(content.style!["color"] ?? 0);
          }
          BlockEmbed divider = BlockEmbed.custom(DividerBlockEmbed(dividerKey));
          delta.insert(divider.toJson());

          break;
        case "view-pager":
          String viewPagerKey = noteEmbedBlocks.generatedViewPagerKey();
          noteEmbedBlocks.viewPagers[viewPagerKey] = ViewPagerData.fromContent(this, content);
          BlockEmbed blockEmbed = BlockEmbed.custom(ViewPagerBlockEmbed(viewPagerKey));
          delta.insert(blockEmbed.toJson());
          break;
        case "file":
          var key = noteEmbedBlocks.generatedFileKey();
          noteEmbedBlocks.files[key] = FileInNote.fromContent(content);
          BlockEmbed blockEmbed = BlockEmbed.custom(FileBlockEmbed(key));
          delta.insert(blockEmbed.toJson());
          break;
        case "text":
          if (content.value is String) {
            // if(!content.value.endsWith("\n")) {
            //   content.value = content.value + "\n";
            // }
            // String text = content.value;

            delta.insert(content.value, content.style);
            break;
          }


        default:
          // if(!content.value.toString().endsWith("\n")) {
          //   content.value = content.value.toString() + "\n";
          // }
          delta.insert(content.value.toString());

          break;
      }
    }

    if (delta.isEmpty) {
      delta.insert("\n");
    }

    if (!delta.last.data.toString().endsWith('\n')) {
      delta.insert("\n");
    }

    return Document.fromDelta(delta);
  }

  Future<void> delete({bool upload = true}) async {
    File file = File(path);
    await file.delete();

    var images = Directory(PathUtils.join(appStorage.notesPath, name, "images"));
    var videos = Directory(PathUtils.join(appStorage.notesPath, name, "videos"));
    var audio = Directory(PathUtils.join(appStorage.notesPath, name, "audio"));
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

  static Note fromFileContent({required String fileContent, required DateTime originalModified, required String filePath}) {

    DateTime? deleted;
    String location = "";

    try {
      Map<String, dynamic> map = jsonDecode(fileContent);
      // created = parsedDateTime(map["created"]);
      // originalCreated = parsedDateTime(map["originalCreated"]);
      // modified = parsedDateTime(map["modified"]);
      // if (map["originalModified"] != null) {
      //   originalModified = parsedDateTime(map["originalModified"]);
      // }

      var created = DateTime.fromMillisecondsSinceEpoch(map["created"]).toLocal();
      var originalCreated = DateTime.fromMillisecondsSinceEpoch(map["originalCreated"]).toLocal();
      var modified = DateTime.fromMillisecondsSinceEpoch(map["modified"]).toLocal();
      originalModified = DateTime.fromMillisecondsSinceEpoch(map["originalModified"]).toLocal();


      if (map["deleted"] != null) {
        deleted = DateTime.fromMillisecondsSinceEpoch(map["deleted"]).toLocal();
      }
      location = map["location"] ?? "";

      List<dynamic> list = map["contents"] ?? [];
      List<Content> contents = [];
      for (dynamic data in list) {
        Map<String, dynamic> map = data;
        contents.add(Content.fromMap(map));
      }

      String filename = PathUtils.basename(filePath);

      Color? backgroundColor = map["backgroundColor"] != null  ? Color(map["backgroundColor"]) : null;
      Color? textColor = map["textColor"] != null  ? Color(map["textColor"]) : null;
      double? lineHeight = map["lineHeight"];
      double? textSize = map["textSize"];

      Note note = Note(
          filename: filename,
          location: location,
          path: filePath,
          created: created,
          modified: modified,
          contents: contents,
          originalCreated: originalCreated,
          originalModified: originalModified,
          deleted: deleted,
      backgroundColor: backgroundColor,
        textColor: textColor,
        lineHeight: lineHeight,
        textSize: textSize
      );
      note.initTitles();
      return note;
    } catch (e) {
      Note note = Note(
          filename: PathUtils.basename(filePath),
          location: location,
          path: filePath,
          created: DateTime.now(),
          modified: DateTime.now(),
          contents: [Content(type: "text", value: fileContent)],
          originalCreated: DateTime.now(),
          originalModified: originalModified,
          deleted: deleted);
      note.initTitles();
      return note;
    }
  }

  Future<void> moveToTrashIfOrphan() async {
    if(location != "" && location != "!Trashes") {
      initTitles();
      var folderFile = File(PathUtils.join(appStorage.notesPath, location));
      if(! await folderFile.exists()) {
        location = "!Trashes";
        deleted = DateTime.now();
        save(upload: false, changeModified: false);
      }
    }
  }

  static Note fromFile(File file) {
    DateTime originalModified = file.lastModifiedSync();
    return Note.fromFileContent(fileContent: file.readAsStringSync(), originalModified: originalModified, filePath: file.path);
  }

  List<Map<String, dynamic>> contentsToMap() {
    List<Map<String, dynamic>> contentList = [];

    for (int i = 0; i < contents.length; i++) {
      contentList.add(contents[i].toMap());
    }
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
      "location": location,
      "created": created.toUtc().millisecondsSinceEpoch,
      "modified": modified.toUtc().millisecondsSinceEpoch,
      "originalCreated": originalCreated.toUtc().millisecondsSinceEpoch,
      "originalModified": originalModified.toUtc().millisecondsSinceEpoch,
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

  String toFileContent() {
    Map<String, dynamic> jsonData = {
      "location": location,
      "created": created.toUtc().millisecondsSinceEpoch,
      "modified": modified.toUtc().millisecondsSinceEpoch,
      "originalCreated": originalCreated.toUtc().millisecondsSinceEpoch,
      "originalModified": originalModified.toUtc().millisecondsSinceEpoch,
      "backgroundColor": backgroundColor?.toHex(),
      "textColor": textColor?.toHex(),
      "deleted": deleted?.toUtc().millisecondsSinceEpoch,
      "contents": contentsToMap()
    };

    String fileContent = jsonEncode(jsonData);
    return fileContent;
  }

  Future<void> save({bool changeModified = true, bool upload = true}) async {
    File file = File(path);

    if (!file.existsSync()) {
      originalCreated = DateTime.now();
      if (!editedCreated) {
        created = DateTime.now();
      }
    }
    if (changeModified) {
      if (!editedModified) {
        modified = DateTime.now();
      }
      originalModified = DateTime.now();
    }

    String fileContent = toFileContent();

    await file.writeAsString(fileContent);
    initTitles();
    if (upload) {
      appWebChannel.uploadNote(note: this, fileContent: fileContent);
    }
    appState.deleteDraft(this);
  }

  Future<void> saveDraft() async {
    var directory = Directory(PathUtils.join(appStorage.notesPath, name));
    if(! await directory.exists()) {
      await directory.create();
    }
    var file = File(PathUtils.join(directory.path, "draft.note"));
    file.writeAsString(toFileContent());
  }

  void initTitles() {
    title = "";
    subtitle = "";
    longSubtitle = "";
    thumbnailImageFilename = null;

    for (Content content in contents) {
      if (content.type == "text" && content.value is String) {
        List<String> textLines = content.value.split("\n");
        if (textLines.length > 1) {
          for (String line in textLines) {
            if (line.trim().isNotEmpty) {
              if (title.isEmpty) {
                title = line;
              } else {
                if (subtitle.isEmpty) {
                  subtitle = line;
                }
                if(longSubtitle.length < 500) {
                  longSubtitle += line + "\n";
                }
              }
            }
          }
        } else {
          if (content.value.trim().isNotEmpty) {
            if (title.isEmpty) {
              title = content.value;
            } else {
              if (subtitle.isEmpty) {
              subtitle = content.value;
              }
              if(longSubtitle.length < 500) {
                longSubtitle += content.value + "\n";
              }
            }
          }
        }
      }
      if (thumbnailImageFilename == null) {
        if (content.type == "img") {
          thumbnailImageFilename = content.value;
        }
      }
      if (thumbnailImageFilename != null && title.isNotEmpty && subtitle.isNotEmpty && longSubtitle.length > 500) {
        break;
      }
    }

  }

  @override
  String toString() {
    return """
       filename: $filename,
        path: $path,
         home: $location,
          contents: ${contents.toString()},
           created: $created,
            originalCreated: $originalCreated,
             modified: $modified,
              originalModified: $originalModified,
              deleted: $deleted
    """;
  }
}