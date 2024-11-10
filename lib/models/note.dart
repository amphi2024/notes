import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:ui';

import 'package:amphi/models/app_theme_core.dart';
import 'package:amphi/utils/random_string.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/channels/app_web_delete.dart';
import 'package:notes/channels/app_web_upload.dart';
import 'package:notes/components/note_editor/embed_block/table/table/table_data.dart';
import 'package:notes/components/note_editor/embed_block/divider/divider_block_embed.dart';
import 'package:notes/components/note_editor/embed_block/image/image_block_embed.dart';
import 'package:notes/components/note_editor/embed_block/sub_note/sub_note_block_embed.dart';
import 'package:notes/components/note_editor/embed_block/table/note_data_block_embed.dart';
import 'package:notes/components/note_editor/embed_block/video/video_block_embed.dart';
import 'package:notes/components/note_editor/embed_block/view_pager/view_pager_data.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/extensions/date_extension.dart';
import 'package:notes/methods/generated_file_name.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/content.dart';
import 'package:notes/models/item.dart';

class Note extends Item{


  NoteEditingController getSubNote(String key) {
    if(subNotes[key] != null) {
      return subNotes[key]!;
    }
    else {
      subNotes[key] = NoteEditingController(note: Note.createdNote("!SubNote") );
      return subNotes[key]!;
    }
  }

  TableData getTable(String key) {
    if(tables[key] != null) {
      return tables[key]!;
    }
    else {
      tables[key ] = TableData();
      return tables[key]!;
    }
  }

  ViewPagerData getViewPager(String key) {
    if(viewPagers[key] != null) {
      return viewPagers[key]!;
    }
    else {
      viewPagers[key ] = ViewPagerData();
      return viewPagers[key]!;
    }
  }

  String generatedTableKey() => generatedKey(tables);
  String generatedSubNoteKey() => generatedKey(subNotes);
  String generatedDividerKey() => generatedKey(dividers);
  String generatedViewPagerKey() => generatedKey(viewPagers);

  String generatedKey(Map map) {
    String key = randomString(9);
    if(map.containsKey(key)) {
      return generatedKey(map);
    }
    else {
      return key;
    }
  }
  String subtitle = "";
  String? thumbnailImageFilename;
  Map<String, TableData> tables = {};
  Map<String, NoteEditingController> subNotes = {};
  Map<String, Color> dividers = {};
  Map<String, ViewPagerData> viewPagers = {};
  double? textSize;
  double? lineHeight;
  String? font;

  List<Content> contents;
  Note({
  required super.filename,
    required super.path,
    required super.location,
    required this.contents,
    required super.created,
    required super.originalCreated,
    required super.modified,
    required super.originalModified,
    super.deleted
}) {
    String filenameWithoutType = filename.split(".").first;
    Directory imagesDir = Directory("${appStorage.notesPath}/${filenameWithoutType}/images");
    Directory videosDir = Directory("${appStorage.notesPath}/${filenameWithoutType}/videos");
    if(!imagesDir.existsSync()) {
      imagesDir.create(recursive:  true);
    }
    if(!videosDir.existsSync()) {
      videosDir.create(recursive:  true);
    }
  }

  Future<File> createdImageFile(String originalPath) async {

    Directory directory = Directory("${appStorage.notesPath}/${filename}/images");
    if(!directory.existsSync()) {
      await directory.create();
    }

    String generatedImageFilename = generatedFileName(
        originalPath.split(".").last, directory.path);

    File originalFile = File(originalPath);
    File file = File("${appStorage.notesPath}/${filename}/images/$generatedImageFilename");
    await originalFile.copy(file.path);

    return file;
  }

  Future<File> createdVideoFile(String originalPath) async {
    Directory directory = Directory("${appStorage.notesPath}/${filename}/videos");
    if(!directory.existsSync()) {
      await directory.create();
    }

    String generatedVideoFilename = generatedFileName(
        originalPath.split(".").last,
        directory.path);

    File originalFile = File(originalPath);
    File file = File(
        "${appStorage.notesPath}/$filename/videos/$generatedVideoFilename");
    await originalFile.copy(file.path);

    return file;
  }

  static Note createdNote(String home) {
    String filename = generatedFileName("note", appStorage.notesPath);
   return Note(
        filename: filename,
        path: "${appStorage.notesPath}/$filename",
        location: home,
        created: DateTime.now(),
        originalCreated: DateTime.now(),
        modified: DateTime.now(),
        originalModified: DateTime.now(),
        contents: []);
  }

    Document toDocument() {
      Delta delta = Delta();

      for(  Content  content in  contents) {
        switch(content.type) {
          case "img":
            BlockEmbed blockEmbed = BlockEmbed.custom(
                ImageBlockEmbed(content.value)
            );
            delta.insert(blockEmbed.toJson());
            break;
          case "video":
            BlockEmbed blockEmbed = BlockEmbed.custom(
                VideoBlockEmbed(content.value)
            );
            delta.insert(blockEmbed.toJson());
            break;
          case "data":
          case "table":
            try {
                String tableKey = generatedKey(tables);
                List<List<Map<String, dynamic>>> data = (content.value as List)
                    .map((innerList) => (innerList as List)
                    .map((item) => item as Map<String, dynamic>)
                    .toList())
                    .toList();
                TableData tableData = TableData();
                tableData.data = data;
                if(content.style?["pages"] is List<dynamic>) {
                  tableData.pages = content.style?["pages"].cast<Map<String, dynamic>>() ?? [ {"type": "table"} ];
                }
                tables[tableKey] = tableData;
                BlockEmbed blockEmbed = BlockEmbed.custom(
                    NoteDataBlockEmbed(tableKey)
                );
                delta.insert(blockEmbed.toJson());
                break;
            }
            catch(e) {
              print(e);
            }
          case "note":
            Map<String, dynamic> subNoteData = content.value;
            List<Content> contentList = [];
            for(dynamic data in subNoteData["contents"] ?? []) {
              Map<String, dynamic> map = data;
              contentList.add(Content.fromMap(map));
            }
            Note subNote = Note(filename: "", path: "", location: "", contents: contentList, created: created, originalCreated: originalCreated, modified: modified, originalModified: originalModified);
            subNote.title = subNoteData["title"] ?? "";

            String subNoteKey = generatedKey(subNotes);
            subNotes[subNoteKey] = NoteEditingController(note: subNote);
            BlockEmbed blockEmbed = BlockEmbed.custom(
                SubNoteBlockEmbed(subNoteKey)
            );
            delta.insert(blockEmbed.toJson());
            break;
          case "divider":
            String dividerKey = generatedDividerKey();
            if(content.style != null) {
              dividers[dividerKey] = Color(content.style!["color"] ?? 0);
            }
            BlockEmbed divider = BlockEmbed.custom(
              DividerBlockEmbed(dividerKey)
            );
            delta.insert(divider.toJson());

            break;
          case "text":
            if(content.value is String) {
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

      if(delta.isEmpty) {
        delta.insert("\n");
      }

      if( !delta.last.data.toString().endsWith('\n') ) {
        delta.insert("\n");
      }

      return Document.fromDelta(delta);
    }

    Future<void> delete({bool upload = true}) async {

      File file = File(path);
       await file.delete();

      for(Content content in contents) {
        if(content.type == "img") {
          File imageFile = File(content.value);
          await imageFile.delete();
        }
        else if(content.type == "video") {
          File videoFile = File(content.value);
          await videoFile.delete();
        }
      }

      if(upload) {
        appWebChannel.deleteNote(note: this);
      }
    }

    static Note fromFileContent({required String fileContent, required DateTime originalModified, required String filePath}) {
      DateTime created = DateTime.now();
      DateTime originalCreated = DateTime.now();
      DateTime modified = DateTime.now();
      DateTime? deleted;
      String location = "";

      try {
        Map<String, dynamic> map = jsonDecode(fileContent);
        created = parsedDateTime(map["created"]);
        originalCreated = parsedDateTime(map["originalCreated"]);
        modified = parsedDateTime(map["modified"]);
        if(map["originalModified"] != null) {
          originalModified = parsedDateTime(map["originalModified"]);
        }
        if(map["deleted"] != null) {
          deleted = parsedDateTime(map["deleted"]);
        }
        location = map["location"] ?? "";

        List<dynamic> list = map["contents"] ?? [];
        List<Content> contents = [];
        for(dynamic data in list) {
          Map<String, dynamic> map = data;
         contents.add(Content.fromMap(map));
        }

        Note note = Note(
            filename: filePath.split("/").last,
            location: location,
            path: filePath,
            created: created,
            modified: modified,
            contents: contents,
            originalCreated: originalCreated,
            originalModified: originalModified,
            deleted: deleted
        );
        note.initTitles();
        return note;
      }
      catch(e) {
        Note note = Note(
            filename: filePath.split("/").last,
            location: location,
            path: filePath,
            created: created,
            modified: modified,
            contents: [Content(
                type: "text",
                value: fileContent
            )],
            originalCreated: originalCreated,
            originalModified: originalModified,
            deleted: deleted
        );
        return note;
      }
    }
  static Note fromFile(File file) {
    DateTime originalModified = file.lastModifiedSync();
    return Note.fromFileContent(fileContent: file.readAsStringSync(), originalModified: originalModified, filePath: file.path);
  }

   List<Map<String, dynamic>> contentsToMap() {
    List< Map<String, dynamic>> contentList = [];

    for(int i = 0 ; i < contents.length ; i++) {
      contentList.add(contents[i].toMap());
    }
    return contentList;
  }

    Future<void> save({bool changeModified = true, bool upload = true}) async {
      File file = File(path);

      if(!file.existsSync()) {
        originalCreated = DateTime.now();
        if(!editedCreated) {
          created = DateTime.now();
        }
      }
      if(changeModified) {
        if(!editedModified) {
          modified = DateTime.now();
        }
        originalModified = DateTime.now();
      }
      Map<String, dynamic> jsonData = {
        "location": location,
        "created": created.toDataString(),
        "modified": modified.toDataString(),
        "originalCreated": originalCreated.toDataString(),
        "originalModified": originalModified.toDataString(),
        "contents": contentsToMap()
      };
      if(backgroundColor != null) {
        jsonData.addAll(
            {"backgroundColor": backgroundColor!.toHex()}
        );
      }
      if(textColor != null) {
        jsonData.addAll(
            {"textColor": textColor!.toHex()}
        );
      }
      if(deleted != null) {
        jsonData.addAll(
            {"deleted": deleted!.toDataString()}
        );
      }

      String fileContent = jsonEncode(jsonData);

      await file.writeAsString(fileContent);
      initTitles();
      if(upload) {
        appWebChannel.uploadNote(note: this, fileContent: fileContent);
      }
    }

  void initTitles() {
    title = "";
    subtitle = "";
    thumbnailImageFilename = null;

    for(Content content in contents) {
      if( (title.isEmpty || subtitle.isEmpty) && content.type == "text") {
        List<String> textLines = content.value.split("\n");
        if(textLines.length > 1) {
           for(String line in textLines) {
             if(line.trim().isNotEmpty) {
               if(title.isEmpty) {
                 title = line;
               }
               else if(subtitle.isEmpty) {
                 subtitle = line;
               }
             }
           }
        }
        else {
          if(content.value.trim().isNotEmpty) {
            if(title.isEmpty) {
              title = content.value;
            }
            else if(subtitle.isEmpty) {
              subtitle = content.value;
            }
          }
        }
      }
      if(thumbnailImageFilename == null) {
        if(content.type == "img") {
          thumbnailImageFilename = content.value;
        }
      }
      if(thumbnailImageFilename != null && title.isNotEmpty && subtitle.isNotEmpty) {
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
extension DateTimeExtension on DateTime {
  String toDataString() {
    return "$year;$month;$day;$hour;$minute;$second";
  }
}